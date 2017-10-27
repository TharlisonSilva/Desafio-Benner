unit uMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TFrmMenu = class(TFrame)
    BtnSaques: TButton;
    Button1: TButton;
    BtnExtratos: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    BtnManutencao: TButton;
    procedure BtnSaquesClick(Sender: TObject);
    procedure BtnManutencaoClick(Sender: TObject);
    procedure BtnExtratosClick(Sender: TObject);
  private
    { Private declarations }
    procedure ChecaTerminal;
  public
    { Public declarations }
  end;

implementation

uses uFormPrincipal;

{$R *.dfm}

procedure TFrmMenu.BtnSaquesClick(Sender: TObject);
begin
  ChecaTerminal;
end;

procedure TFrmMenu.ChecaTerminal;
begin
  //FAZ A CHECAGEM SE EXISTE ALGUM SALDO NO TERMINAL
  FrmPrincipal.FrmSaque.AlimentaArrays;
  if FrmPrincipal.FrmSaque.saldo = 0 then
    begin
      ShowMessage(' Terminal em manuten��o !')
    end
    else
      FrmPrincipal.AlterarTela(2);{ Seleciona a tela de Login }
end;

procedure TFrmMenu.BtnExtratosClick(Sender: TObject);
begin
    // Fa�o a busca dos ultimos saques feitos !
    FrmPrincipal.FrmRelatorioSaque.memo.lines.clear;
    FrmPrincipal.FrmRelatorioSaque.memo.lines.add('Data Saque:  '+ DateToStr(Date) + #13#10);
    FrmPrincipal.FrmRelatorioSaque.memo.lines.add(FrmPrincipal.FrmSaque.ResumoTransa��o);

    FrmPrincipal.AlterarTela(5);
end;

procedure TFrmMenu.BtnManutencaoClick(Sender: TObject);
begin
  { Seleciona a tela de Manuten��es }
  FrmPrincipal.AlterarTela(3);
end;

end.
