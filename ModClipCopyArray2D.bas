Attribute VB_Name = "ModClipCopyArray2D"
Option Explicit

'ClipCopyArray2D   ・・・元場所：FukamiAddins3.ModArray    
'ClipboardCopy     ・・・元場所：FukamiAddins3.ModClipboard
'CheckArray2D      ・・・元場所：FukamiAddins3.ModArray    
'CheckArray2DStart1・・・元場所：FukamiAddins3.ModArray    

'------------------------------


'配列の処理関係のプロシージャ

'------------------------------



'------------------------------


Sub ClipCopyArray2D(Array2D)
'2次元配列を変数宣言用のテキストデータに変換して、クリップボードにコピーする
'20210805
    
    '引数チェック
    Call CheckArray2D(Array2D, "Array2D")
    Call CheckArray2DStart1(Array2D, "Array2D")
    
    Dim I&, J&, K&, M&, N& '数え上げ用(Long型)
    N = UBound(Array2D, 1)
    M = UBound(Array2D, 2)
    
    Dim TmpValue
    Dim Output$
    
    Output = ""
    For I = 1 To N
        If I = 1 Then
            Output = Output & String(3, Chr(9)) & "Array(Array("
        Else
            Output = Output & String(3, Chr(9)) & "Array("
        End If
        
        For J = 1 To M
            TmpValue = Array2D(I, J)
            If IsNumeric(TmpValue) Then
                Output = Output & TmpValue
            Else
                Output = Output & """" & TmpValue & """"
            End If
            
            If J < M Then
                Output = Output & ","
            Else
                Output = Output & ")"
            End If
        Next J
        
        If I < N Then
            Output = Output & ", _" & vbLf
        Else
            Output = Output & ")"
        End If
    Next I
    
    Output = "Application.Transpose(Application.Transpose( _" & vbLf & Output & " _" & vbLf & String(3, Chr(9)) & "))"
    
    Call ClipboardCopy(Output, True)
    
End Sub

Private Sub ClipboardCopy(ByVal InputClipText, Optional MessageIrunaraTrue As Boolean = False)
'入力テキストをクリップボードに格納
'配列ならば列方向をTabわけ、行方向を改行する。
'20210719作成
    
    '入力した引数が配列か、配列の場合は1次元配列か、2次元配列か判定
    Dim HairetuHantei%
    Dim Jigen1%, Jigen2%
    If IsArray(InputClipText) = False Then
        '入力引数が配列でない
        HairetuHantei = 0
    Else
        On Error Resume Next
        Jigen2 = UBound(InputClipText, 2)
        On Error GoTo 0
        
        If Jigen2 = 0 Then
            HairetuHantei = 1
        Else
            HairetuHantei = 2
        End If
    End If
    
    'クリップボードに格納用のテキスト変数を作成
    Dim Output$
    Dim I%, J%, K%, M%, N% '数え上げ用(Integer型)
    
    If HairetuHantei = 0 Then '配列でない場合
        Output = InputClipText
    ElseIf HairetuHantei = 1 Then '1次元配列の場合
    
        If LBound(InputClipText, 1) <> 1 Then '最初の要素番号が1出ない場合は最初の要素番号を1にする
            InputClipText = Application.Transpose(Application.Transpose(InputClipText))
        End If
        
        N = UBound(InputClipText, 1)
        
        Output = ""
        For I = 1 To N
            If I = 1 Then
                Output = InputClipText(I)
            Else
                Output = Output & vbLf & InputClipText(I)
            End If
            
        Next I
    ElseIf HairetuHantei = 2 Then '2次元配列の場合
        
        If LBound(InputClipText, 1) <> 1 Or LBound(InputClipText, 2) <> 1 Then
            InputClipText = Application.Transpose(Application.Transpose(InputClipText))
        End If
        
        N = UBound(InputClipText, 1)
        M = UBound(InputClipText, 2)
        
        Output = ""
        
        For I = 1 To N
            For J = 1 To M
                If J < M Then
                    Output = Output & InputClipText(I, J) & Chr(9)
                Else
                    Output = Output & InputClipText(I, J)
                End If
                
            Next J
            
            If I < N Then
                Output = Output & Chr(10)
            End If
        Next I
    End If
    
    
    'クリップボードに格納'参考 https://www.ka-net.org/blog/?p=7537
    With CreateObject("Forms.TextBox.1")
        .MultiLine = True
        .Text = Output
        .SelStart = 0
        .SelLength = .TextLength
        .Copy
    End With

    '格納したテキスト変数をメッセージ表示
    If MessageIrunaraTrue Then
        MsgBox ("「" & Output & "」" & vbLf & _
                "をクリップボードにコピーしました。")
    End If
    
End Sub

Private Sub CheckArray2D(InputArray, Optional HairetuName$ = "配列")
'入力配列が2次元配列かどうかチェックする
'20210804

    Dim Dummy2%, Dummy3%
    On Error Resume Next
    Dummy2 = UBound(InputArray, 2)
    Dummy3 = UBound(InputArray, 3)
    On Error GoTo 0
    If Dummy2 = 0 Or Dummy3 <> 0 Then
        MsgBox (HairetuName & "は2次元配列を入力してください")
        Stop
        Exit Sub '入力元のプロシージャを確認するために抜ける
    End If

End Sub

Private Sub CheckArray2DStart1(InputArray, Optional HairetuName$ = "配列")
'入力2次元配列の開始番号が1かどうかチェックする
'20210804

    If LBound(InputArray, 1) <> 1 Or LBound(InputArray, 2) <> 1 Then
        MsgBox (HairetuName & "の開始要素番号は1にしてください")
        Stop
        Exit Sub '入力元のプロシージャを確認するために抜ける
    End If

End Sub


