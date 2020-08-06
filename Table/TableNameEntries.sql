use [DatabaseName]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- ===============================
--        File: TableNameEntries
--     Created: 07/28/2020
--     Updated: 08/06/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Table name entries
-- ===============================
create table [dbo].[TableNameEntries](
  [idDPD] [bigint] identity (1, 1) not null,
  [serialNumber] [nvarchar](255) not null,
  [partNumber] [nvarchar](255) null,
  [datetimeValue] [datetime2](7) null,
  [created_date] [datetime2](7) null,
  [modified_date] [datetime2](7) null,
  constraint [PK_TableNameEntries] primary key clustered
  (
    [serialNumber] asc
  )with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [primary]
) on [primary]
go

alter table [dbo].[TableNameEntries] add  default (getdate()) for [created_date]
go

alter table [dbo].[TableNameEntries] add  default (getdate()) for [modified_date]
go