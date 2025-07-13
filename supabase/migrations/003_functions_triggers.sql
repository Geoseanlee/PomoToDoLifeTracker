-- Function to automatically create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to call the function on user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update task's actual pomodoros count
CREATE OR REPLACE FUNCTION update_task_pomodoro_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Update actual_pomodoros count for the task when a work session is completed
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND NEW.type = 'work' AND NEW.status = 'completed' THEN
        UPDATE tasks 
        SET actual_pomodoros = (
            SELECT COUNT(*) 
            FROM pomodoro_sessions 
            WHERE task_id = NEW.task_id 
            AND type = 'work' 
            AND status = 'completed'
        )
        WHERE id = NEW.task_id;
    END IF;
    
    -- If deleting a completed work session, update the count
    IF TG_OP = 'DELETE' AND OLD.type = 'work' AND OLD.status = 'completed' THEN
        UPDATE tasks 
        SET actual_pomodoros = (
            SELECT COUNT(*) 
            FROM pomodoro_sessions 
            WHERE task_id = OLD.task_id 
            AND type = 'work' 
            AND status = 'completed'
        )
        WHERE id = OLD.task_id;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Trigger to update pomodoro count
CREATE TRIGGER update_task_pomodoro_count_trigger
    AFTER INSERT OR UPDATE OR DELETE ON pomodoro_sessions
    FOR EACH ROW
    EXECUTE FUNCTION update_task_pomodoro_count();

-- Function to get daily statistics
CREATE OR REPLACE FUNCTION get_daily_stats(user_uuid UUID, target_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
    total_work_sessions INTEGER,
    total_work_minutes INTEGER,
    total_break_minutes INTEGER,
    tasks_completed INTEGER,
    category_stats JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE((
            SELECT COUNT(*)::INTEGER 
            FROM pomodoro_sessions ps 
            WHERE ps.user_id = user_uuid 
            AND ps.type = 'work' 
            AND ps.status = 'completed'
            AND DATE(ps.start_time) = target_date
        ), 0) as total_work_sessions,
        
        COALESCE((
            SELECT SUM(actual_duration)::INTEGER / 60
            FROM pomodoro_sessions ps 
            WHERE ps.user_id = user_uuid 
            AND ps.type = 'work' 
            AND ps.status = 'completed'
            AND DATE(ps.start_time) = target_date
        ), 0) as total_work_minutes,
        
        COALESCE((
            SELECT SUM(actual_duration)::INTEGER / 60
            FROM pomodoro_sessions ps 
            WHERE ps.user_id = user_uuid 
            AND ps.type IN ('short_break', 'long_break')
            AND ps.status = 'completed'
            AND DATE(ps.start_time) = target_date
        ), 0) as total_break_minutes,
        
        COALESCE((
            SELECT COUNT(DISTINCT t.id)::INTEGER
            FROM tasks t
            WHERE t.user_id = user_uuid
            AND DATE(t.completed_at) = target_date
        ), 0) as tasks_completed,
        
        COALESCE((
            SELECT jsonb_agg(
                jsonb_build_object(
                    'category_name', COALESCE(c.name, 'Uncategorized'),
                    'work_sessions', category_data.session_count,
                    'work_minutes', category_data.work_minutes
                )
            )
            FROM (
                SELECT 
                    t.category_id,
                    COUNT(ps.id) as session_count,
                    SUM(ps.actual_duration) / 60 as work_minutes
                FROM pomodoro_sessions ps
                JOIN tasks t ON ps.task_id = t.id
                WHERE ps.user_id = user_uuid
                AND ps.type = 'work'
                AND ps.status = 'completed' 
                AND DATE(ps.start_time) = target_date
                GROUP BY t.category_id
            ) category_data
            LEFT JOIN categories c ON category_data.category_id = c.id
        ), '[]'::jsonb) as category_stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; 