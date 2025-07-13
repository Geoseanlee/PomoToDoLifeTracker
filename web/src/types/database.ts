export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      categories: {
        Row: {
          id: string
          name: string
          color: string
          user_id: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          color?: string
          user_id: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          color?: string
          user_id?: string
          created_at?: string
          updated_at?: string
        }
      }
      tasks: {
        Row: {
          id: string
          title: string
          description: string | null
          estimated_pomodoros: number
          actual_pomodoros: number
          priority: number
          status: string
          category_id: string | null
          user_id: string
          completed_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          title: string
          description?: string | null
          estimated_pomodoros?: number
          actual_pomodoros?: number
          priority?: number
          status?: string
          category_id?: string | null
          user_id: string
          completed_at?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          title?: string
          description?: string | null
          estimated_pomodoros?: number
          actual_pomodoros?: number
          priority?: number
          status?: string
          category_id?: string | null
          user_id?: string
          completed_at?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      pomodoro_sessions: {
        Row: {
          id: string
          task_id: string
          user_id: string
          type: 'work' | 'short_break' | 'long_break'
          planned_duration: number
          actual_duration: number | null
          start_time: string
          end_time: string | null
          status: 'started' | 'paused' | 'completed' | 'cancelled'
          notes: string | null
          created_at: string
        }
        Insert: {
          id?: string
          task_id: string
          user_id: string
          type: 'work' | 'short_break' | 'long_break'
          planned_duration: number
          actual_duration?: number | null
          start_time?: string
          end_time?: string | null
          status?: 'started' | 'paused' | 'completed' | 'cancelled'
          notes?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          task_id?: string
          user_id?: string
          type?: 'work' | 'short_break' | 'long_break'
          planned_duration?: number
          actual_duration?: number | null
          start_time?: string
          end_time?: string | null
          status?: 'started' | 'paused' | 'completed' | 'cancelled'
          notes?: string | null
          created_at?: string
        }
      }
      user_profiles: {
        Row: {
          id: string
          email: string | null
          full_name: string | null
          avatar_url: string | null
          locale: string
          timezone: string
          work_duration: number
          short_break_duration: number
          long_break_duration: number
          sessions_until_long_break: number
          sound_enabled: boolean
          notification_enabled: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email?: string | null
          full_name?: string | null
          avatar_url?: string | null
          locale?: string
          timezone?: string
          work_duration?: number
          short_break_duration?: number
          long_break_duration?: number
          sessions_until_long_break?: number
          sound_enabled?: boolean
          notification_enabled?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string | null
          full_name?: string | null
          avatar_url?: string | null
          locale?: string
          timezone?: string
          work_duration?: number
          short_break_duration?: number
          long_break_duration?: number
          sessions_until_long_break?: number
          sound_enabled?: boolean
          notification_enabled?: boolean
          created_at?: string
          updated_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      get_daily_stats: {
        Args: {
          user_uuid: string
          target_date?: string
        }
        Returns: {
          total_work_sessions: number
          total_work_minutes: number
          total_break_minutes: number
          tasks_completed: number
          category_stats: Json
        }[]
      }
    }
    Enums: {
      [_ in never]: never
    }
  }
} 