unit recipeparserunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, Graphics;

procedure gridColResize(colIndex: integer; Grid: TStringGrid);
procedure parseIngredients(recipeFile: string; Grid: TstringGrid);
procedure parseRecipe(recipeFile: string; Grid: TstringGrid);
function getEmbeddedRecipeImage(recipeFilename: string; index: integer): TPicture;

implementation

uses bitmapmanipulation;

procedure gridColResize(colIndex: integer; Grid: TStringGrid);
var
  i: integer;
  minWidth: integer = 0;
begin
  for i := 0 to Grid.ColCount - 1 do
  begin
    if i <> colIndex then
      minWidth += Grid.ColWidths[i];
  end;

  Grid.ColWidths[colIndex] := Grid.Width - minWidth;
end;

procedure parseIngredients(recipeFile: string; Grid: TstringGrid);
var
  csv: TStringGrid;
  recipeItem: array of string;
  GUID: TGuid;
  i, j: integer;
  ingstr: string = '[ingredients]';
  partstr: string;
begin
  if FileExists(recipeFile) then
  begin
    csv := TStringGrid.Create(nil);
    try
      csv.LoadFromCSVFile(recipeFile, ',', True, 0, True);

      if csv.RowCount > 0 then
      begin
        grid.Columns.Clear;

        partstr := '';
        //Get Ingredients and build grid
        for i := 0 to csv.RowCount - 1 do
        begin
          if csv.Cells[0, i].Substring(0, Length(ingstr)) = ingstr then
          begin
            partstr := csv.Cells[0, i].Substring(length(ingstr),
              length(csv.Cells[0, i]) - Length(ingstr)).Replace('{',
              '').Replace('}', '');
          end;

          if (partstr <> '') and (csv.Cells[0, i].Substring(0, 1) <> '[') then
          begin
            if csv.Cells[0, i].Substring(0, Length(ingstr)) <> ingstr then
              grid.InsertRowWithValues(grid.RowCount,
                [partstr, csv.Cells[0, i], csv.Cells[2, i], csv.Cells[3, i]]);
          end;
        end;
        gridColResize(1, Grid);
      end;
    finally
      csv.Free;
    end;
  end;
end;

//ToDo: Convert to JSON and Store
//Our Parse (name, length, author, about, address, cost)
//Parse manual (name, title, length, (4 fields),author, about, address)
procedure parseRecipe(recipeFile: string; Grid: TstringGrid);
var
  csv: TStringGrid;
  recipeItem: array of string;
  GUID: TGuid;
  i, j: integer;
begin
  if FileExists(recipeFile) then
  begin
    csv := TStringGrid.Create(nil);
    try
      csv.LoadFromCSVFile(recipeFile, ',', True, 0, True);
      if csv.RowCount > 0 then
      begin
        insert(recipefile, recipeItem, Length(recipeItem));
        CreateGUID(GUID); //ToDo: Check if we create proper GUID (if 0> err)
        insert(GUIDToString(GUID), recipeItem, Length(recipeItem));
        for j := 0 to Grid.ColCount - 1 do
        begin
          for i := 0 to csv.ColCount - 1 do
          begin
            if Grid.Columns.Items[j].Title.Caption = csv.Cells[i, 0] then
            begin
              insert(csv.Cells[i, 1], recipeItem, Length(recipeItem));
            end;
          end;
        end;
      end;
      Grid.InsertRowWithValues(Grid.RowCount, recipeItem);
    finally
      csv.Free;
    end;
  end;
end;

function getEmbeddedRecipeImage(recipeFilename: string; index: integer): TPicture;
var
  bitmap: TPicture;
  recipeFileData, base64Images: TStringList;
  i: integer;
  phototype: array of string = ('[recipe-photo]', '[author-photo]');
begin
  recipeFileData := TStringList.Create;
  recipeFileData.LoadFromFile(recipeFilename);

  base64Images := TStringList.Create;

  bitmap := TPicture.Create;


  for i := 0 to recipeFileData.Count - 1 do
  begin
    if copy(recipeFileData.Strings[i], 0, Length(phototype[0])) = phototype[0] then
      base64Images.Add(copy(recipeFileData.Strings[i], Length(phototype[0])+3+1,
        Length(recipeFileData.Strings[i])));
  end;

  bitmap.Jpeg.LoadFromStream(base64tostream(base64Images.Strings[index]));

  Result := bitmap;

end;


end.
