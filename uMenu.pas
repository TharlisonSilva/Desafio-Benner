unit uMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TFrmMenu = class(TFrame)
    BtnSaques: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    BtnManutencao: TButton;
    procedure BtnSaquesClick(Sender: TObject);
    procedure BtnManutencaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses uFormPrincipal;

{$R *.dfm}

procedure TFrmMenu.BtnSaquesClick(Sender: TObject);
begin
  { Seleciona a tela de Login }
  FrmPrincipal.AlterarTela(2);
end;

procedure TFrmMenu.BtnManutencaoClick(Sender: TObject);
begin
  { Seleciona a tela de Manutenções }
  FrmPrincipal.AlterarTela(3);
end;

end.
