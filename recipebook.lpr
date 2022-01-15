program recipebook;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, recipebookunit, IdeLazLogger, lazlogger, imagefpreviewpopupunit
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TRecipeBookForm, RecipeBookForm);
  Application.CreateForm(TFormImagePreview, FormImagePreview);
  Application.Run;
end.

