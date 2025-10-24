# models

> This document for design models

## Task

### Relationships

- `belongs_to :user` - Each task belongs to a user
- `has_many :entries` - A task can have multiple task entries (class: `TaskEntry`, dependent: destroy)

### Enums

#### cycle_reset_type

- `none` - No automatic reset
- `daily` - Reset daily
- `weekly` - Reset weekly
- `monthly` - Reset monthly
- `custom_days` - Reset after custom number of days

#### status

- `active` - Task is active
- `paused` - Task is paused
- `completed` - Task is completed
- `archived` - Task is archived

### Fields & Validations

- `name` - Required, max 100 characters
- `type` - Required (STI for task types)
- `current_value` - Required, must be numeric
- `step_value` - Required, must be numeric
- `theme_emoji` - Optional, max 10 characters
- `theme_color` - Optional, max 7 characters (hex color)
- `step_unit` - Optional, max 50 characters (e.g., "cups", "pages", "minutes")
- `cycle_reset_days` - Required if cycle_reset_type is `custom_days`, must be integer > 0

### Task Types (STI)

- **NumericalTask** - Numerical task (can increase or decrease)
- **ProgressTask** - Progress task (e.g., drink 8 cups of water, read 30 pages)
- **ReductionTask** - Reduction task (e.g., quit smoking, reduce coffee intake)
- **DurationTask** - Duration task (e.g., study English for 30 minutes, run for 1 hour)
- **CustomTask** - Custom task (user-defined rules)
