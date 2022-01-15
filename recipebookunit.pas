unit recipebookunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ExtCtrls,
  StdCtrls, ComCtrls, SpkToolbar, spkt_Tab, spkt_Pane, spkt_Buttons,
  spkt_Checkboxes, FileUtil;

type

  { TRecipeBookForm }

  TRecipeBookForm = class(TForm)
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
    procedure ImagePreviewMouseEnter(Sender: TObject);
    procedure SpkToolbar1TabChanged(Sender: TObject);
    procedure StringGridBrowserSelection(Sender: TObject; aCol, aRow: integer);
    procedure TimerTimeSepTimer(Sender: TObject);

  private

  public

  end;

var
  RecipeBookForm: TRecipeBookForm;

implementation

uses recipeparserunit, bitmapmanipulation, imagefpreviewpopupunit;

{$R *.lfm}

type
  ArrayString = array of string;

{ TRecipeBookForm }

//Icon Attribution: Entypo pictograms by Daniel Bruce — www.entypo.com

procedure LoadRecipes(Grid: TStringGrid);
var
  recipefile: string;
begin
  for recipefile in FindAllFiles(GetCurrentDir + PathDelim + 'recipes',
      '*.recipebook', False) do
  begin
    parseRecipe(recipefile, Grid);
  end;
end;

//ToDo: Ingredients: Unit, x, name, alternatives, optionality
procedure TRecipeBookForm.FormCreate(Sender: TObject);
begin
  PageControl1.ShowTabs := False;
  LoadRecipes(StringGridBrowser);

  if StringGridBrowser.RowCount > 0 then
    StringGridBrowserSelection(self, 0, 1);
end;

procedure TRecipeBookForm.ImagePreviewMouseEnter(Sender: TObject);
begin
  FormImagePreview.Top := RecipeBookForm.Top + (PageControl1.Top +
    ((ImagePreview.Height div 2) - (FormImagePreview.Height div 2)));

  FormImagePreview.Left := RecipeBookForm.Left +
    (Panel2.Left + ((ImagePreview.Width div 2) - FormImagePreview.Width div 2));

  FormImagePreview.Image1.Picture := ImagePreview.Picture;
  FormImagePreview.Show;
end;

procedure TRecipeBookForm.SpkToolbar1TabChanged(Sender: TObject);
begin
  PageControl1.ActivePageIndex := SpkToolbar1.TabIndex;
end;

procedure TRecipeBookForm.StringGridBrowserSelection(Sender: TObject;
  aCol, aRow: integer);
var
  imgfile, recipefile: string;
begin
  recipefile := StringGridBrowser.Cells[0, arow];
  parseIngredients(recipefile, StringGridIngredients);

  imgfile := 'img/' + copy(ExtractFileName(recipefile), 0,
    Length(ExtractFileName(recipefile)) - Length(ExtractFileExt(recipefile))) + '.jpeg';


  if FileExists(imgfile) then
    ImagePreview.Picture.Jpeg.LoadFromFile(imgfile)
  else
    ImagePreview.Picture := getEmbeddedRecipeImage(recipefile, 0);
end;

procedure TRecipeBookForm.TimerTimeSepTimer(Sender: TObject);
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
