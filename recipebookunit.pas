unit recipebookunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ExtCtrls,
  StdCtrls, ComCtrls, SpkToolbar, spkt_Tab, spkt_Pane, spkt_Buttons,
  spkt_Checkboxes, FileUtil;

type

  { TForm1 }

  TForm1 = class(TForm)
    ImageListGridHeaders16: TImageList;
    ImagePreview: TImage;
    ImageGuide: TImage;
    Label1: TLabel;
    LabelTimer: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    SpkCheckbox1: TSpkCheckbox;
    SpkLargeButton1: TSpkLargeButton;
    SpkPane1: TSpkPane;
    SpkRadioButton1: TSpkRadioButton;
    SpkSmallButton1: TSpkSmallButton;
    SpkTab1: TSpkTab;
    SpkTab2: TSpkTab;
    SpkTab3: TSpkTab;
    SpkToolbar1: TSpkToolbar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    StringGridBrowser: TStringGrid;
    StringGridIngredients: TStringGrid;
    StringGridRecipeSteps: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TimerTimeSep: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure SpkToolbar1TabChanged(Sender: TObject);
    procedure StringGridBrowserSelection(Sender: TObject; aCol, aRow: integer);
    procedure TimerTimeSepTimer(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;

implementation

uses recipeparserunit;

{$R *.lfm}

type
  ArrayString = array of string;

{ TForm1 }

//Icon Attribution: Entypo pictograms by Daniel Bruce — www.entypo.com

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
            partstr := csv.Cells[0, i].Substring(length(ingstr), length(csv.Cells[0, i]) - Length(ingstr)).Replace('{', '').Replace('}', '');
          end;

          if (partstr <> '') and (csv.Cells[0, i].Substring(0, 1) <> '[') then
          begin
            if csv.Cells[0, i].Substring(0, Length(ingstr)) <> ingstr then
              grid.InsertRowWithValues(grid.RowCount, [partstr, csv.Cells[0, i], csv.Cells[2, i], csv.Cells[3, i]]);
          end;
        end;
        gridColResize(1, Grid);
      end;
    finally
      csv.Free;
    end;
  end;
end;


procedure LoadRecipes(Grid: TStringGrid);
var
  recipefile: string;
begin
  for recipefile in FindAllFiles(GetCurrentDir + PathDelim + 'recipes', '*.recipebook', False) do
  begin
    parseRecipe(recipefile, Grid);
  end;
end;

//ToDo: Ingredients: Unit, x, name, alternatives, optionality
procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.ShowTabs := False;
  LoadRecipes(StringGridBrowser);

  if StringGridBrowser.RowCount > 0 then
    parseIngredients(StringGridBrowser.Cells[0, 1], StringGridIngredients);

  //playing with image
  ImagePreview.Picture.LoadFromFile('img/recipe.jpeg');
end;

procedure TForm1.SpkToolbar1TabChanged(Sender: TObject);
begin
  PageControl1.ActivePageIndex := SpkToolbar1.TabIndex;
end;

procedure TForm1.StringGridBrowserSelection(Sender: TObject; aCol, aRow: integer);
begin
  parseIngredients(StringGridBrowser.Cells[0, arow], StringGridIngredients);
end;

procedure TForm1.TimerTimeSepTimer(Sender: TObject);
var
  timerCaption: string;
begin
  timerCaption := LabelTimer.Caption;
  if timerCaption.IndexOf(':') > 0 then
    LabelTimer.Caption := '16' + ' ' + '20'
  else
    LabelTimer.Caption := '16' + ':' + '20';
end;


end.








