unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Interpolation, IntervalArithmetic;

type
  TMainForm = class(TForm)
    HeaderLabel: TLabel;
    DataPointsEdit: TEdit;
    DataPointsLabel: TLabel;
    InputGroupBox: TGroupBox;
    EvaluationPointLabel: TLabel;
    EvaluationPointEdit: TEdit;
    CalculationModeLabel: TLabel;
    NormalArithmeticsRadioButton: TRadioButton;
    IntervalArithmeticsRadioButton: TRadioButton;
    CalculateButton: TButton;
    OutputGroupBox: TGroupBox;
    LagrangePolynomialSolutionLabel: TLabel;
    LagrangeCoefficientsSolutionEdit: TEdit;
    LagrangeValueSolutionLabel: TLabel;
    LagrangeValueSolutionEdit: TEdit;
    NevilleValueSolutionLabel: TLabel;
    NevilleValueSolutionEdit: TEdit;
    DoubleEndIntervalArithmeticsRadioButton: TRadioButton;
    procedure CalculateButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure ResetOutputFields;
begin
MainForm.LagrangeCoefficientsSolutionEdit.Clear;
MainForm.LagrangeValueSolutionEdit.Clear;
MainForm.NevilleValueSolutionEdit.Clear;
end;

function ArrayToString(ary : TExtendedArray) : string; overload;
var i : Integer;
begin
  result := ' ';
  for i := 0 to Length(ary)-1 do
    result := result + ' ' + FloatToStr(ary[i]);
end;

function ArrayToString(ary : TIntervalArray) : string; overload;
var i : Integer;
begin
  result := ' ';
  for i := 0 to Length(ary)-1 do
    result := result + ' ' + IntervalToString(ary[i]);
end;

procedure DisplayValueSolutions(lagrangeValueSolution: Extended; nevilleValueSolution: Extended); overload;
begin
    MainForm.LagrangeValueSolutionEdit.Text := FloatToStr(lagrangeValueSolution);
    MainForm.NevilleValueSolutionEdit.Text  := FloatToStr(nevilleValueSolution);
end;


procedure DisplayValueSolutions(lagrangeValueSolution: Interval; nevilleValueSolution: Interval); overload;
begin
  MainForm.LagrangeValueSolutionEdit.Text := IntervalToString(lagrangeValueSolution);
  MainForm.NevilleValueSolutionEdit.Text := IntervalToString(nevilleValueSolution);
end;

procedure DisplayCoefficientsSolution(lagrangeCoefficients : TExtendedArray); overload;
begin
  MainForm.LagrangeCoefficientsSolutionEdit.Text := ArrayToString(lagrangeCoefficients);
end;

procedure DisplayCoefficientsSolution(lagrangeCoefficients : TIntervalArray); overload;
begin
  MainForm.LagrangeCoefficientsSolutionEdit.Text := ArrayToString(lagrangeCoefficients);
end;

function SplitString(input : string) : TStrings;
begin
  result := TStringList.Create;
  ExtractStrings([' '], [], PChar(input), result);
end;

function ExtractDataPoints(input: string) : TExtendedArray;
var tmp: TStrings;
var i : Integer;
begin
  tmp := SplitString(input);
  SetLength(result, tmp.Count);
  for i := 0 to tmp.Count - 1 do
    result[i] := StrToFloat(tmp[i]);
end;

function ExtractIntervalDataPoints(input: string; doubleEnd : boolean) : TIntervalArray;
var tmp: TStrings;
var i : Integer;
begin
  tmp := SplitString(input);
  if(doubleEnd) then begin
    SetLength(result, tmp.Count div 2);
    for i := 0 to tmp.Count - 1 do begin
      if(i mod 2 = 0) then
        result[i div 2].a := left_read(tmp[i])
      else
        result[i div 2].b := right_read(tmp[i])
    end
  end else
  begin
  SetLength(result, tmp.Count);
  for i := 0 to tmp.Count - 1 do
    result[i] := int_read(tmp[i]);
  end
end;

function ExtractIntervalDataPoint(input : string; doubleEnd : boolean) : Interval;
var tmp : TStrings;
begin
  if(doubleEnd) then begin
    tmp := SplitString(input);
    result.a := left_read(tmp[0]);
    result.b := right_read(tmp[1]);
  end else
    result := int_read(input);
end;

procedure CalculateNormalArithmetics(evaluationPointText, dataPointsText: string);
var evaluationPoint: Extended;
var dataPoints, dataArguments, dataValues : TExtendedArray;
var lagrangeValueSolution: Extended;
var lagrangeCoefficients : TExtendedArray;
var nevilleValueSolution: Extended;
var problemDegree : Integer;
var tmp, i : Integer;
begin
  evaluationPoint := StrToFloat(evaluationPointText);
  dataPoints := ExtractDataPoints(dataPointsText);
  if (Length(dataPoints) mod 2) <> 0 then
    ShowMessage('Invalid data points format.')
  else begin
    problemDegree := Trunc(Length(dataPoints) / 2);
    SetLength(dataArguments, problemDegree);
    SetLength(dataValues, problemDegree);
    for i := 0 to Length(dataPoints) - 1 do begin
      if i mod 2 = 0 then
        dataArguments[Trunc(i/2)] := dataPoints[i]
      else
        dataValues[Trunc(i/2)] := dataPoints[i];
      end;
    lagrangeValueSolution := Interpolation.Lagrange(problemDegree - 1, dataArguments, dataValues, evaluationPoint, tmp);
    lagrangeCoefficients := Interpolation.LagrangeCoefficients(problemDegree - 1, dataArguments, dataValues, tmp);
    nevilleValueSolution := Interpolation.Neville(problemDegree - 1, dataArguments, dataValues, evaluationPoint, tmp);
    DisplayValueSolutions(lagrangeValueSolution, nevilleValueSolution);
    DisplayCoefficientsSolution(lagrangeCoefficients);
  end;
end;

procedure CalculateIntervalArithmetics(evaluationPointText, dataPointsText: string; doubleEnd : boolean);
var evaluationPoint: Interval;
var dataPoints, dataArguments, dataValues : TIntervalArray;
var lagrangeValueSolution: Interval;
var nevilleValueSolution: Interval;
var lagrangeCoefficientsSolution : TIntervalArray;
var problemDegree : Integer;
var tmp, i : Integer;
begin
  evaluationPoint := ExtractIntervalDataPoint(evaluationPointText, doubleEnd);
  dataPoints := ExtractIntervalDataPoints(dataPointsText, doubleEnd);
  if (Length(dataPoints) mod 2) <> 0 then
    ShowMessage('Invalid data points format.')
  else begin
    problemDegree := Trunc(Length(dataPoints) / 2);
    SetLength(dataArguments, problemDegree);
    SetLength(dataValues, problemDegree);
    for i := 0 to Length(dataPoints) - 1 do begin
      if i mod 2 = 0 then
        dataArguments[Trunc(i/2)] := dataPoints[i]
      else
        dataValues[Trunc(i/2)] := dataPoints[i];
      end;
    lagrangeValueSolution := Interpolation.Lagrange(problemDegree - 1, dataArguments, dataValues, evaluationPoint, tmp);
    lagrangeCoefficientsSolution := Interpolation.LagrangeCoefficients(problemDegree - 1, dataArguments, dataValues, tmp);
    nevilleValueSolution := Interpolation.Neville(problemDegree - 1, dataArguments, dataValues, evaluationPoint, tmp);
    DisplayValueSolutions(lagrangeValueSolution, nevilleValueSolution);
    DisplayCoefficientsSolution(lagrangeCoefficientsSolution);
  end;
end;

procedure TMainForm.CalculateButtonClick(Sender: TObject);
begin
  ResetOutputFields();
  if Length(MainForm.DataPointsEdit.Text) = 0 then begin
    MainForm.DataPointsEdit.SetFocus;
    ShowMessage('Data Points are required.');
  end
  else if Length(MainForm.EvaluationPointEdit.Text) = 0 then begin
    MainForm.EvaluationPointEdit.SetFocus;
    ShowMessage('Evaluation Point is required.');
  end
  else begin
    try
      if MainForm.NormalArithmeticsRadioButton.Checked then
        CalculateNormalArithmetics(MainForm.EvaluationPointEdit.Text, MainForm.DataPointsEdit.Text)
      else if MainForm.IntervalArithmeticsRadioButton.Checked then
        CalculateIntervalArithmetics(MainForm.EvaluationPointEdit.Text, MainForm.DataPointsEdit.Text, false)
      else if MainForm.DoubleEndIntervalArithmeticsRadioButton.Checked then
        CalculateIntervalArithmetics(MainForm.EvaluationPointEdit.Text, MainForm.DataPointsEdit.Text, true)
    except
      MainForm.DataPointsEdit.SelectAll;
      MainForm.DataPointsEdit.SetFocus;
      ShowMessage('Invalid input data.')
    end;
  end;
end;
end.
