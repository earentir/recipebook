unit imagefpreviewpopupunit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TFormImagePreview }

  TFormImagePreview = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseLeave(Sender: TObject);
  private

  public

  end;

var
  FormImagePreview: TFormImagePreview;

implementation

{$R *.lfm}

{ TFormImagePreview }

procedure TFormImagePreview.FormCreate(Sender: TObject);
begin

end;

procedure TFormImagePreview.Image1MouseLeave(Sender: TObject);
begin
  FormImagePreview.Hide;
end;

end.
