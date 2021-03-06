use [DatabaseName]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- ==================================================
--        File: extractInsertUpdateTemporaryTable
--     Created: 07/27/2020
--     Updated: 08/06/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Extract insert update temporary table
-- ==================================================
create procedure [dbo].[extractInsertUpdateTemporaryTable]
  -- Parameters
  @optionMode nvarchar(255)
as
begin
  -- Set nocount on added to prevent extra result sets from interfering with select statements
  set nocount on

  -- Declare variables
  declare @countTempTable as int
  declare @padCharacter as nvarchar(1)
  declare @numberCharacters as int

  -- Set variables
  set @countTempTable = 0
  set @padCharacter = '0'
  set @numberCharacters = 6

  -- Omit characters
  set @optionMode = dbo.OmitCharacters(@optionMode, '48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if empty string
  if @optionMode = ''
    begin
      -- Set parameter to null if empty string
      set @optionMode = nullif(@optionMode, '')
    end

  -- Check if option mode is extract entries
  if @optionMode = 'extractEntries'
    begin
      -- Delcare temporary table
      declare @EntryTranslationTemp table
      (
        ettID int identity (1, 1) primary key,
        serialNumber nvarchar(255) not null,
        partNumber nvarchar(255) not null,
        datetimeValue nvarchar(255) not null,
        revisionValue nvarchar(255) not null,
        shippingCompany nvarchar(255) not null
      )

      -- Insert select records
      insert into @EntryTranslationTemp (serialNumber, partNumber, datetimeValue, revisionValue, shippingCompany)
      select
      ltrim(rtrim(dmpd.serialNumber)),
      ltrim(rtrim(dmpd.partNumber)),
      ltrim(rtrim(dmpd.datetimeValue)),
      ltrim(rtrim('RevisionValue')),
      ltrim(rtrim('ShippingCompany'))
      from dbo.TableNameEntries dmpd
      group by dmpd.serialNumber, dmpd.partNumber, dmpd.datetimeValue

      -- Set maximum count of temporary table
      set @countTempTable =
      (
        -- Select record
        select
        max(ett.ettID)
        from @EntryTranslationTemp ett
      )

      -- Check if there are records to process
      if @countTempTable > 0
        begin
          -- Update records
          update ett
          set
          ett.partNumber = ltrim(rtrim(et.translationNumber))
          from dbo.EntryTranslation et
          left join @EntryTranslationTemp ett on ett.partNumber = et.partNumber
        end

      -- Select records
      select
      replicate(@padCharacter, @numberCharacters - len(convert(nvarchar(255), ltrim(rtrim(row_number() over (order by ltrim(rtrim(ett.serialNumber)))))))) + convert(nvarchar(255), ltrim(rtrim(row_number() over (order by ltrim(rtrim(ett.serialNumber)))))) as [Record Number],
      ltrim(rtrim(ett.serialNumber)) as [Serial Number],
      ltrim(rtrim(ett.partNumber)) as [Part Number],
      format(dateadd(day, 0, cast(ett.datetimeValue as datetime2(7))), 'MM/dd/yyyy', 'en-us') as [ Date Time Value],
      ltrim(rtrim(ett.revisionValue)) as [Revision Value],
      ltrim(rtrim(ett.shippingCompany)) as [Shipping Company]
      from @EntryTranslationTemp ett
    end
end