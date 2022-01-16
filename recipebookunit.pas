unit recipebookunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ExtCtrls,
  StdCtrls, ComCtrls, Spin, SpkToolbar, spkt_Tab, spkt_Pane, spkt_Buttons,
  spkt_Checkboxes, FileUtil;

type

  { TRecipeBookForm }

  TRecipeBookForm = class(TForm)
    ComboBoxHours: TComboBox;
    ComboBoxMinutes: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    ImageListGridHeaders16: TImageList;
    ImageGuide: TImage;
    ImagePreview: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LabelTimer: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    PageControlMain: TPageControl;
    PanelDetailsLeft: TPanel;
    PanelDetails: TPanel;
    PanelBrowser: TPanel;
    PanelBrowserRight: TPanel;
    PanelImagePreview: TPanel;
    PanelIngredients: TPanel;
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
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheetBrowser: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TimerTimeSep: TTimer;
    procedure ComboBoxHoursKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ImagePreviewMouseEnter(Sender: TObject);
    procedure PanelImagePreviewResize(Sender: TObject);
    procedure SpkToolbar1TabChanged(Sender: TObject);
    procedure StringGridBrowserSelection(Sender: TObject; aCol, aRow: integer);
    procedure TimerTimeSepTimer(Sender: TObject);
    procedure ImagePreviewResize(Sender: TObject);

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
var
  i: integer;
begin
  PageControlMain.ShowTabs := False;
  LoadRecipes(StringGridBrowser);

  ImagePreviewResize(Self);

  if StringGridBrowser.RowCount > 0 then
    StringGridBrowserSelection(self, 0, 1);

  for i := 0 to 59 do
  begin
    if i <= 12 then
      ComboBoxHours.Items.Add(IntToStr(i));

    ComboBoxMinutes.Items.Add(IntToStr(i));
  end;
  ComboBoxHours.ItemIndex := 0;
  ComboBoxMinutes.ItemIndex := 0;

end;

procedure TRecipeBookForm.ComboBoxHoursKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  writeln(key);

  if ((key > 46) and (key < 58)) or (key = 8) or ((key >= 35) and (key <= 40)) then
  //key := key
  else
    key := 0;
end;

procedure TRecipeBookForm.ImagePreviewResize(Sender: TObject);
begin
  if ImagePreview.Width <= (ImagePreview.Parent as TPanel).Width then
  begin
    ImagePreview.Height := (ImagePreview.Parent as TPanel).Height;
    ImagePreview.Width := (ImagePreview.Parent as TPanel).Height;

    ImagePreview.Left := ((ImagePreview.Parent as TPanel).Width div 2) -
      (ImagePreview.Width div 2);
  end;
end;

procedure TRecipeBookForm.FormResize(Sender: TObject);
begin
  ImagePreviewResize(Self);
  StringGridBrowser.Width := PanelBrowser.Width div 2;
end;

procedure TRecipeBookForm.ImagePreviewMouseEnter(Sender: TObject);
begin
  FormImagePreview.Top := RecipeBookForm.Top + (PageControlMain.Top +
    ((ImagePreview.Height div 2) - (FormImagePreview.Height div 2)));

  FormImagePreview.Left := RecipeBookForm.Left +
    (PanelBrowserRight.Left + ((ImagePreview.Width div 2) -
    FormImagePreview.Width div 2));

  FormImagePreview.Image1.Picture := ImagePreview.Picture;
  FormImagePreview.Show;
end;

procedure TRecipeBookForm.PanelImagePreviewResize(Sender: TObject);
begin
  ImagePreviewResize(Self);
end;

procedure TRecipeBookForm.SpkToolbar1TabChanged(Sender: TObject);
begin
  PageControlMain.ActivePageIndex := SpkToolbar1.TabIndex;
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
