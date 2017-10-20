unit uRelatorioSaque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmRelatorioSaque = class(TFrame)
    Memo: TMemo;
    BtnRetornar: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses uFormPrincipal;

{$R *.dfm}

end.
