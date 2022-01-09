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
    SpkLargeButton2: TSpkLargeButton;
    SpkPane1: TSpkPane;
    SpkPane2: TSpkPane;
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

uses recipeparserunit, bitmapmanipulation;

{$R *.lfm}

type
  ArrayString = array of string;

{ TForm1 }

//Icon Attribution: Entypo pictograms by Daniel Bruce — www.entypo.com

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








