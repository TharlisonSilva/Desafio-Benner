unit uSaque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uRelatorioSaque, Generics.Collections;

type
  TFrmSaque = class(TFrame)
    Label1: TLabel;
    BtnConfirmar: TButton;
    BtnCancelar: TButton;
    BtnUm: TButton;
    Btn2: TButton;
    Btn3: TButton;
    Btn4: TButton;
    Btn5: TButton;
    Btn6: TButton;
    Btn7: TButton;
    Btn8: TButton;
    Btn9: TButton;
    Btn0: TButton;
    BtnClear: TButton;
    PnlValor: TPanel;
    BtnBackspace: TButton;
    procedure BtnUmClick(Sender: TObject);
    procedure Btn2Click(Sender: TObject);
    procedure Btn3Click(Sender: TObject);
    procedure Btn4Click(Sender: TObject);
    procedure Btn5Click(Sender: TObject);
    procedure Btn6Click(Sender: TObject);
    procedure Btn7Click(Sender: TObject);
    procedure Btn8Click(Sender: TObject);
    procedure Btn9Click(Sender: TObject);
    procedure Btn0Click(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnBackspaceClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnConfirmarClick(Sender: TObject);
  private
          {Declarações privadas }
  public
    var
      ResumoTransação: String;
      Cedula: Array of Integer;
      Quantidade: Array of Integer;
      DadosTransação : TDictionary<Integer, Integer>;

    procedure Saque(Quantia: Integer);
    procedure Tecla(Valor: integer);{ Processa a tecla pressionada }
    procedure OrdenaArrays(Cedulas: Array of Integer; Quantidade: Array of Integer); //ORDENA OS ARRAYS PARA CALCULO INTERNO.
    procedure AlimentaArrays;//ALIMENTAÇÃO DOS ARRAYS COM DADOS DO BANCO, PARA PROCESSAMENTO INTERNO.
    function saldo():Integer;//CONSULTA DE SALDO ATUAL NO TERMINAL.
    function RelatorioTransação():String;
    function ContagemCedulas(Quantia: Integer):Integer;
  end;

implementation

uses uFormPrincipal;

{$R *.dfm}

procedure TFrmSaque.BtnUmClick(Sender: TObject);
begin
  Tecla(1);
end;

function TFrmSaque.ContagemCedulas(Quantia: Integer):Integer;
var
  QuantiaAtual, Indice: Integer;
begin
  QuantiaAtual := 0;
  Indice       := 0;

  for Indice := Low(Cedula) to High(Cedula) do
    begin
      if Trunc(Quantia / cedula[Indice]) <> 0 then
        begin
          DadosTransação.Add(cedula[Indice], Trunc(Quantia / cedula[Indice]));
          QuantiaAtual := QuantiaAtual + (cedula[Indice] * (Trunc(Quantia / cedula[Indice])));
          Quantia  := Quantia mod cedula[Indice];
        end;
    end;
  result := QuantiaAtual;
end;

procedure TFrmSaque.OrdenaArrays(Cedulas: Array of Integer; Quantidade: Array of Integer);
var
  Indice, auxiliar: integer;
  Trocou:Boolean;
begin
  Trocou := True;

  //ORDENAÇÃO EM ORDEM CRESCENTE NO FORMATO BOLHA.
  while(Trocou <> False)do
    begin
      Trocou := False;
      for Indice := low(cedulas) to high(cedulas)-1 do
        begin
          if (cedulas[Indice] < cedulas[Indice +1]) then
            begin

              //ORDENA CEDULAS.
              auxiliar := cedulas[Indice];
              cedulas[Indice]:= cedulas[Indice +1];
              cedulas[Indice +1] := auxiliar;

              //ORDENA QUANTIDADE PARALELO AS CEDULAS.
              auxiliar := Quantidade[Indice];
              Quantidade[Indice]:= Quantidade[Indice +1];
              Quantidade[Indice +1] := auxiliar;

              Trocou := True;
            end;
        end;
    end;
end;

function TFrmSaque.RelatorioTransação: String;
var
  Indice  :Integer;
  Extrato :String;
begin
  Extrato := '';
  for Indice in DadosTransação.Keys do
    begin
      ResumoTransação := ResumoTransação + IntToStr(Indice) + '  --> ' + IntToStr(DadosTransação[Indice]) + #13#10;
      Extrato         := Extrato + IntToStr(Indice) + '  --> ' + IntToStr(DadosTransação[Indice]) + #13#10 ;
    end;
  ResumoTransação   := 'Data Saque:  '+ DateToStr(Date) + #13#10 +ResumoTransação + ' > --------------' + #13#10;
  Result := Extrato;
end;

function TFrmSaque.saldo(): Integer;
var
  QuantiaTerminal, Indice: integer;
begin
  Indice          := 0;
  QuantiaTerminal := 0;

  for Indice := Low(cedula) to High(cedula) do
      Inc(QuantiaTerminal, (Quantidade[Indice] * cedula[Indice]));

  Result := QuantiaTerminal;
end;

procedure TFrmSaque.Saque(Quantia: Integer);
var
  QuantiaAtual, Indice, valor: integer;
begin
  DadosTransação          := TDictionary<Integer, Integer>.create();
  Indice                  := 0;

  if Quantia = 0 then
    begin
      ShowMessage(' Quantia Invalida para saque !');
      PnlValor.Caption := '0';
      FrmPrincipal.AlterarTela(1);
    end
  else
    begin
      AlimentaArrays;
      if length(cedula) <> 0 then
        begin
          OrdenaArrays(cedula,Quantidade);
          if Saldo() < Quantia then
            begin
              ShowMessage(' Quantia Não permitida !');
              PnlValor.Caption := '0';
            end
          else
            begin
              if ContagemCedulas(Quantia) <> Quantia then
                begin
                  ShowMessage(' Quantia não permitida ! ');
                  PnlValor.Caption := '0';
                end
              else
                begin
                 FrmPrincipal.cdsNotas.FindFirst;
                 FrmPrincipal.CdsNotas.IndexName := 'VALORDESC';
                 FrmPrincipal.cdsNotas.FindFirst;
                 for valor in DadosTransação.Keys do
                  begin
                    for Indice := Low(cedula) to High(cedula) do
                      begin
                        if (FrmPrincipal.cdsNotas.FieldByName('valor').AsInteger = valor) AND (valor = cedula[Indice])then
                          begin
                            FrmPrincipal.cdsNotas.Edit;
                            FrmPrincipal.cdsNotas.FieldByName('quantidade').AsInteger := (quantidade[indice] - DadosTransação[valor]);
                            FrmPrincipal.cdsNotas.Post;
                            FrmPrincipal.cdsNotas.ApplyUpdates(0);
                          end;
                        FrmPrincipal.cdsNotas.FindNext;
                      end;
                    FrmPrincipal.cdsNotas.FindFirst;
                  end;
                 ShowMessage('Data Saque: ' + DateToStr(date)+ #13#10 +RelatorioTransação());
                 PnlValor.Caption := '0';
                end;
            end;
        end
      else
        ShowMessage(' Terminal em manutenção !');
    end;
end;

procedure TFrmSaque.Tecla(Valor: integer);
begin
  if PnlValor.Caption = '0' then
    PnlValor.Caption := IntToStr(Valor)
  else
    PnlValor.Caption := PnlValor.Caption + IntToStr(Valor);
end;

procedure TFrmSaque.Btn2Click(Sender: TObject);
begin
  Tecla(2);
end;

procedure TFrmSaque.Btn3Click(Sender: TObject);
begin
  Tecla(3);
end;

procedure TFrmSaque.Btn4Click(Sender: TObject);
begin
  Tecla(4);
end;

procedure TFrmSaque.Btn5Click(Sender: TObject);
begin
  Tecla(5);
end;

procedure TFrmSaque.Btn6Click(Sender: TObject);
begin
  Tecla(6);
end;

procedure TFrmSaque.Btn7Click(Sender: TObject);
begin
  Tecla(7);
end;

procedure TFrmSaque.Btn8Click(Sender: TObject);
begin
  Tecla(8);
end;

procedure TFrmSaque.Btn9Click(Sender: TObject);
begin
  Tecla(9);
end;

//ALIMENTAÇÃO DOS ARRAYS COM DADOS DO BANCO, PARA PROCESSAMENTO INTERNO.
procedure TFrmSaque.AlimentaArrays;
var
  indice, contador:  integer;
begin
   indice   := 0;
   contador := 0;
   setLength(cedula, 0);
   setLength(quantidade, 0);

 //BUSCA DAS CEDULAS PARA ORDENAMENTO EM ARRAY.
    while (FrmPrincipal.cdsNotas.Active) and (indice <> 2) do
      begin
        if (FrmPrincipal.cdsNotas.FieldByName('valor').AsInteger = 1)  OR
           (FrmPrincipal.cdsNotas.FieldByName('valor').AsInteger = 100)then
              Inc(indice);

        if FrmPrincipal.cdsNotas.FieldByName('quantidade').AsInteger > 0 then
          begin
            setLength(cedula, length(cedula)+1);
            setLength(Quantidade, length(quantidade)+1);
            cedula[contador]:= FrmPrincipal.cdsNotas.FieldByName('valor').AsInteger;
            Quantidade[contador]:= FrmPrincipal.cdsNotas.FieldByName('quantidade').AsInteger;
            Inc(contador);
          end;
        FrmPrincipal.cdsNotas.FindNext;
      end;
    FrmPrincipal.cdsNotas.FindFirst;
end;

procedure TFrmSaque.Btn0Click(Sender: TObject);
begin
  Tecla(0);
end;

procedure TFrmSaque.BtnCancelarClick(Sender: TObject);
begin
  PnlValor.Caption := '0';
  FrmPrincipal.AlterarTela(1);
end;

procedure TFrmSaque.BtnClearClick(Sender: TObject);
begin
  PnlValor.Caption := '0';
end;

procedure TFrmSaque.BtnConfirmarClick(Sender: TObject);
begin
Saque(StrToIntDef(PnlValor.Caption, 0));
end;

procedure TFrmSaque.BtnBackspaceClick(Sender: TObject);
begin
  if Length(PnlValor.Caption) <= 1 then
    PnlValor.Caption := '0'
  else
    PnlValor.Caption := copy(PnlValor.Caption, 1, Length(PnlValor.Caption)-1);
end;

end.
