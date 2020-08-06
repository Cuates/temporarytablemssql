use [DatabaseName]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- ==============================
--        File: EntryTranslation
--     Created: 07/28/2020
--     Updated: 07/29/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Entry translation
-- ==============================
create table [dbo].[EntryTranslation](
  [etID] [bigint] identity (1, 1) not null,
  [created_date] [datetime2](7) not null,
  [modified_date] [datetime2](7) not null,
  [cluserid] [int] not null,
  [partNumber] [nvarchar](255) not null,
  [translationNumber] [nvarchar](255) not null,
  constraint [PK_EntryTranslation] primary key clustered
  (
    [partNumber] asc
  )with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [primary]
) on [primary]
go

alter table [dbo].[EntryTranslation] add  default (getdate()) for [created_date]
go

alter table [dbo].[EntryTranslation] add  default (getdate()) for [modified_date]
go