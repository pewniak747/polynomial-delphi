object MainForm: TMainForm
  Left = 200
  Top = 130
  Width = 430
  Height = 414
  Caption = 'Polynomial Interpolation'
  Color = clBtnFace
  Constraints.MaxHeight = 414
  Constraints.MinHeight = 414
  Constraints.MinWidth = 430
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    414
    376)
  PixelsPerInch = 96
  TextHeight = 13
  object HeaderLabel: TLabel
    Left = 8
    Top = 8
    Width = 260
    Height = 13
    Caption = 'Polynomial Interpolation by Tomasz Pewi'#324'ski inf106638'
  end
  object InputGroupBox: TGroupBox
    Left = 8
    Top = 32
    Width = 400
    Height = 153
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Input'
    TabOrder = 0
    DesignSize = (
      400
      153)
    object DataPointsLabel: TLabel
      Left = 42
      Top = 24
      Width = 55
      Height = 13
      Align = alCustom
      Alignment = taRightJustify
      Caption = 'Data Points'
    end
    object EvaluationPointLabel: TLabel
      Left = 20
      Top = 56
      Width = 77
      Height = 13
      Align = alCustom
      Alignment = taRightJustify
      Caption = 'Evaluation Point'
    end
    object CalculationModeLabel: TLabel
      Left = 15
      Top = 88
      Width = 82
      Height = 13
      Align = alCustom
      Alignment = taRightJustify
      Caption = 'Calculation Mode'
    end
    object DataPointsEdit: TEdit
      Left = 112
      Top = 20
      Width = 271
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object EvaluationPointEdit: TEdit
      Left = 112
      Top = 52
      Width = 271
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object NormalArithmeticsRadioButton: TRadioButton
      Left = 120
      Top = 88
      Width = 169
      Height = 17
      Caption = 'Floating Point Arithmetics'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object IntervalArithmeticsRadioButton: TRadioButton
      Left = 120
      Top = 104
      Width = 113
      Height = 17
      Caption = 'Interval Arithmetics'
      TabOrder = 3
    end
    object CalculateButton: TButton
      Left = 296
      Top = 112
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Calculate'
      TabOrder = 4
      OnClick = CalculateButtonClick
    end
    object DoubleEndIntervalArithmeticsRadioButton: TRadioButton
      Left = 120
      Top = 120
      Width = 169
      Height = 17
      Caption = 'Double-End Interval Arithmetics'
      TabOrder = 5
    end
  end
  object OutputGroupBox: TGroupBox
    Left = 8
    Top = 192
    Width = 401
    Height = 175
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Output'
    TabOrder = 1
    DesignSize = (
      401
      175)
    object LagrangePolynomialSolutionLabel: TLabel
      Left = 8
      Top = 120
      Width = 155
      Height = 13
      Caption = 'Coefficients (Lagrange Algorithm)'
    end
    object LagrangeValueSolutionLabel: TLabel
      Left = 8
      Top = 26
      Width = 141
      Height = 13
      Caption = 'Solution (Lagrange Algorithm):'
    end
    object NevilleValueSolutionLabel: TLabel
      Left = 8
      Top = 74
      Width = 128
      Height = 13
      Caption = 'Solution (Neville Algorithm):'
    end
    object LagrangeCoefficientsSolutionEdit: TEdit
      Left = 8
      Top = 136
      Width = 385
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 0
    end
    object LagrangeValueSolutionEdit: TEdit
      Left = 8
      Top = 42
      Width = 385
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 1
    end
    object NevilleValueSolutionEdit: TEdit
      Left = 8
      Top = 90
      Width = 385
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 2
    end
  end
end
