Attribute VB_Name = "BODModule"
'send data 分割してRESTful WEB APIでPOSTする
Sub UpdateDB()
Dim i, j, k, x, y As Integer, sht As Worksheet, startdate As String
Dim strCn As String, strSQL, rs, JSONstr As String

x = ActiveCell.Column
y = ActiveCell.row
Set sht = ThisWorkbook.ActiveSheet

If x < 8 Then
    x = 8
End If

'****************************************************************************
'データ初期化
'↓**URL地址  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
host_url = "http://10.1.251.111:8080/ora" '開始時間
Bigintime = Now()
JSONstr = "["
addcount = 0
Dim jsonNAME, jsonTEAM, jsonWORKDATE, jsonWORKHOURS, jsonTYPE As String
'****************************************************************************

startdate = date_change(sht.Cells(1, x))
strSQL = "delete from workschedule where Workdate >= " & startdate & "  "


'****************************************************************************
'DB削除
target_url = host_url & "/db/insert"
rs = RESTfulAPI.postSQLbyURL(target_url, strSQL)
If rs = "-1" Then Exit Sub
'****************************************************************************

Dim enddate, endflg As Integer, TEAM As String, insertdate(100) As String, WORKHOURS As Single

enddate = 90 '90日間データをDBへ更新する
For i = 1 To enddate
    If sht.Cells(1, x + i - 1) = "" Then
        enddate = i - 1
        Exit For
    End If
    insertdate(i) = date_change(sht.Cells(1, x + i - 1))
Next
endflg = 0


For i = 2 To 1000
    If Len(sht.Cells(i, 2)) < 1 Then
        Exit For
    Else
        TEAM = sht.Cells(i, 2)
    End If
'処理対象Team 指定
    If TEAM = "MF1" Or TEAM = "MB" Or TEAM = "MC" Or TEAM = "MDMF" Or TEAM = "Other" Or TEAM = "MF2" Or TEAM = "KA" Or TEAM = "MF3" Or TEAM = "MF4" Or TEAM = "MGR" Or TEAM = "TECH" Or TEAM = "OJT" Or TEAM = "Unit" Or TEAM = "DevOps" Then
        endflg = 1
        strSQL = ""
        For k = 1 To enddate
            If Len(sht.Cells(i, x + k - 1)) > 0 Then
                If IsNumeric(sht.Cells(i, x + k - 1)) Then
                    'strSQL = "insert into workschedule values('" & LCase(sht.Cells(i, 6)) & "','" & TEAM & "','" & insertdate(k) & "'," & sht.Cells(i, x + k - 1) & ", 'W') "
                    'strSQL = strSQL & ";"
                    
'****************************************************************************
'JSON配列データ作成
                    jsonNAME = LCase(sht.Cells(i, 6))
                    jsonTEAM = TEAM
                    jsonWORKDATE = insertdate(k)
                    jsonWORKHOURS = sht.Cells(i, x + k - 1)
                    jsonTYPE = "W"
'****************************************************************************
                    
                Else
                    worktype = Left(sht.Cells(i, x + k - 1), 1)
                    worktime = Right(sht.Cells(i, x + k - 1), Len(sht.Cells(i, x + k - 1)) - 1)
                    'strSQL = "insert into workschedule values('" & LCase(sht.Cells(i, 6)) & "','" & TEAM & "','" & insertdate(k) & "'," & worktime & ", '" & worktype & "') "
                    'strSQL = strSQL & ";"
                    
'****************************************************************************
'JSON配列データ作成
                    jsonNAME = LCase(sht.Cells(i, 6))
                    jsonTEAM = TEAM
                    jsonWORKDATE = insertdate(k)
                    jsonWORKHOURS = worktime
                    jsonTYPE = worktype
'****************************************************************************

                End If
                
                
'****************************************************************************
'JSONデータ組み立て
                If JSONstr = "[" Then
                '第一件ではないの場合
                JSONstr = JSONstr + "{""TEAM"":""" & jsonTEAM & """,""WORKHOURS"":" & jsonWORKHOURS _
                               & ",""TYPE"":""" & jsonTYPE & """,""NAME"":""" & jsonNAME _
                               & """,""WORKDATE"":""" & jsonWORKDATE & """}"
                addcount = addcount + 1
                Else
                 '第一件ではないの場合、”,”付く
                 JSONstr = JSONstr + ",{""TEAM"":""" & jsonTEAM & """,""WORKHOURS"":" & jsonWORKHOURS _
                               & ",""TYPE"":""" & jsonTYPE & """,""NAME"":""" & jsonNAME _
                               & """,""WORKDATE"":""" & jsonWORKDATE & """}"
                 addcount = addcount + 1
                End If
                
                'cn.Execute strSQL
                
                '?件まで組み立て一括にDBへInsertする
                If addcount Mod 70 = 0 Then
                   JSONstr = LCase(JSONstr) & "]"
                   ThisWorkbook.Sheets("ResourceActual").Range("SF1").Value = JSONstr
                   '↓**URL地址↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
                   target_url = host_url & "/workschedule/adds"
                  '↑**URL地址↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
                   rs = RESTfulAPI.postSQLbyBody(target_url, JSONstr)
                   JSONstr = "["
                End If
                
'****************************************************************************
                
            End If
            
        Next
    Else
        If endflg > 0 Then
            Exit For
        End If
    End If
Next

'****************************************************************************
'残り分を一括にDBへInsertする
           If JSONstr <> "]" Then
                   JSONstr = LCase(JSONstr) & "]"
                   ThisWorkbook.Sheets("ResourceActual").Range("SF1").Value = JSONstr
                   '↓**URL地址↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
                   target_url = host_url & "/workschedule/adds"
                  '↑**URL地址↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
                   rs = RESTfulAPI.postSQLbyBody(target_url, JSONstr)
                   'JSONstr = "["
           End If
'時間 計算
    Endtime = CInt((TimeValue(Now()) - TimeValue(Bigintime)) * 24 * 60 * 60)
    Debug.Print addcount & "件は" & Endtime & "秒掛かりました"
    
    MsgBox "開始時間：" & Bigintime & chr(10) & _
           "終了時間：" & Now & chr(10) & _
             addcount & "件が成功に処理しました　" & chr(10) & _
             Endtime & "秒掛かりました"
'****************************************************************************

End Sub

'ODBC使えなく、RESTful Web API 1件ずつに処理します
Sub UpdateDBbyWebAPI()

Dim i, j, k, x, y As Integer, sht As Worksheet, startdate As String

Dim strCn As String, strSQL, rs As String

addcount = 0
Bigintime = Now()

x = ActiveCell.Column
y = ActiveCell.row
Set sht = ThisWorkbook.ActiveSheet

If x < 8 Then
    x = 8
End If
startdate = date_change(sht.Cells(1, x))
strSQL = "delete from workschedule where Workdate >= " & startdate & "  "
'strSQL = strSQL & ";"
'cn.Execute strSQL
'result = RESTfulAPIv10.deleteWorkschedule(startdate)

'↓**URL地址↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
target_url = "http://10.1.251.111:9090/db/insert"
'↑**URL地址↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
rs = RESTfulAPI.postSQLbyURL(target_url, strSQL)

If rs = "-1" Then Exit Sub

Dim enddate, endflg As Integer, TEAM As String, insertdate(100) As String, WORKHOURS As Single
enddate = 90
For i = 1 To enddate
    If sht.Cells(1, x + i - 1) = "" Then
        enddate = i - 1
        Exit For
    End If
    insertdate(i) = date_change(sht.Cells(1, x + i - 1))
Next
endflg = 0
For i = 2 To 1000
    If Len(sht.Cells(i, 2)) < 1 Then
        Exit For
    Else
        TEAM = sht.Cells(i, 2)
    End If
'    If team = "MF1" Or team = "MF2" Or team = "MF3" Or team = "MF4" Or team = "MGR" Or team = "TECH" Then
'    If team = "MF1" Or team = "MF2" Or team = "MF3" Or team = "MF4" Or team = "MGR" Or team = "TECH" Or team = "OJT" Or team = "Unit" Or team = "IAT" Then
'    If team = "MF1" Or team = "MB" Or team = "MC" Or team = "MDMF" Or team = "Other" Or team = "MF2" Or team = "KA" Or team = "MF3" Or team = "MF4" Or team = "MGR" Or team = "TECH" Or team = "OJT" Or team = "Unit" Or team = "IAT" Then
    If TEAM = "MF1" Or TEAM = "MB" Or TEAM = "MC" Or TEAM = "MDMF" Or TEAM = "Other" Or TEAM = "MF2" Or TEAM = "KA" Or TEAM = "MF3" Or TEAM = "MF4" Or TEAM = "MGR" Or TEAM = "TECH" Or TEAM = "OJT" Or TEAM = "Unit" Or TEAM = "DevOps" Then
'    If team = "MF1" Then
        endflg = 1
        strSQL = ""
        For k = 1 To enddate
            If Len(sht.Cells(i, x + k - 1)) > 0 Then
                If IsNumeric(sht.Cells(i, x + k - 1)) Then
                    strSQL = "insert into workschedule values('" & LCase(sht.Cells(i, 6)) & "','" & TEAM & "','" & insertdate(k) & "'," & sht.Cells(i, x + k - 1) & ", 'W') "
                    'strSQL = strSQL & ";"
                Else
                    worktype = Left(sht.Cells(i, x + k - 1), 1)
                    worktime = Right(sht.Cells(i, x + k - 1), Len(sht.Cells(i, x + k - 1)) - 1)
                    strSQL = "insert into workschedule values('" & LCase(sht.Cells(i, 6)) & "','" & TEAM & "','" & insertdate(k) & "'," & worktime & ", '" & worktype & "') "
                    'strSQL = strSQL & ";"
                End If
                'cn.Execute strSQL
                rs = RESTfulAPI.postSQLbyURL(target_url, strSQL)
                addcount = addcount + 1
                If rs = "-1" Then Exit Sub
            End If
        Next
    Else
        If endflg > 0 Then
            Exit For
        End If
    End If
Next
'strSQL = "delete workschedule;"
'cn.Execute strSQL
'cn.Close

'時間計算
    Endtime = CInt((TimeValue(Now()) - TimeValue(Bigintime)) * 24 * 60 * 60)
    Debug.Print addcount & "件は" & Endtime & "秒掛かりました"
    
    MsgBox "開始時間：" & Bigintime & chr(10) & _
           "終了時間：" & Now & chr(10) & _
             addcount & "件が成功に処理しました　" & chr(10) & _
             Endtime & "秒掛かりました"
End Sub
Sub UpdateOracelByODBC()
Dim i, j, k, x, y As Integer, sht As Worksheet, startdate As String
Dim cn As New ADODB.Connection
Dim rs As New ADODB.Recordset
Dim strCn As String, strSQL As String

Bigintime = Now()
addcount = 0

'****20170930廃止
'SQL ServerDB接続
'strCn = "Provider=sqloledb;Server=CDC-SRV01;Database=BODtest;Uid=sa;Pwd=sa;"
'****

'OracleDB接続
strCn = "DRIVER={Oracle in instantclient_12_1};Data Source=Ora-wow64;Uid=BODTEST;Pwd=BODTEST1111$;"
cn.Open strCn
x = ActiveCell.Column
y = ActiveCell.row
Set sht = ThisWorkbook.ActiveSheet
'If x < 10 Then
'    x = 10
'End If
If x < 8 Then
    x = 8
End If
startdate = date_change(sht.Cells(1, x))
strSQL = "delete from workschedule where Workdate >= '" & startdate & "';"
cn.Execute strSQL
Dim enddate, endflg As Integer, TEAM As String, insertdate(100) As String, WORKHOURS As Single
enddate = 90
For i = 1 To enddate
    If sht.Cells(1, x + i - 1) = "" Then
        enddate = i - 1
        Exit For
    End If
    insertdate(i) = date_change(sht.Cells(1, x + i - 1))
Next
endflg = 0
For i = 2 To 1000
    If Len(sht.Cells(i, 2)) < 1 Then
        Exit For
    Else
        TEAM = sht.Cells(i, 2)
    End If
'    If team = "MF1" Or team = "MF2" Or team = "MF3" Or team = "MF4" Or team = "MGR" Or team = "TECH" Then
'    If team = "MF1" Or team = "MF2" Or team = "MF3" Or team = "MF4" Or team = "MGR" Or team = "TECH" Or team = "OJT" Or team = "Unit" Or team = "IAT" Then
'    If team = "MF1" Or team = "MB" Or team = "MC" Or team = "MDMF" Or team = "Other" Or team = "MF2" Or team = "KA" Or team = "MF3" Or team = "MF4" Or team = "MGR" Or team = "TECH" Or team = "OJT" Or team = "Unit" Or team = "IAT" Then
    If TEAM = "MF1" Or TEAM = "MB" Or TEAM = "MC" Or TEAM = "MDMF" Or TEAM = "Other" Or TEAM = "MF2" Or TEAM = "KA" Or TEAM = "MF3" Or TEAM = "MF4" Or TEAM = "MGR" Or TEAM = "TECH" Or TEAM = "OJT" Or TEAM = "Unit" Or TEAM = "DevOps" Then
'    If team = "MF1" Then
        endflg = 1
        strSQL = ""
        For k = 1 To enddate
            If Len(sht.Cells(i, x + k - 1)) > 0 Then
                If IsNumeric(sht.Cells(i, x + k - 1)) Then
                    strSQL = "insert into workschedule values('" & LCase(sht.Cells(i, 6)) & "','" & TEAM & "','" & insertdate(k) & "'," & sht.Cells(i, x + k - 1) & ", 'W') ;"
                Else
                    worktype = Left(sht.Cells(i, x + k - 1), 1)
                    worktime = Right(sht.Cells(i, x + k - 1), Len(sht.Cells(i, x + k - 1)) - 1)
                    strSQL = "insert into workschedule values('" & LCase(sht.Cells(i, 6)) & "','" & TEAM & "','" & insertdate(k) & "'," & worktime & ", '" & worktype & "') ;"
                End If
                cn.Execute strSQL
                addcount = addcount + 1
            End If
        Next
    Else
        If endflg > 0 Then
            Exit For
        End If
    End If
Next
strSQL = "delete * workschedule;"
'cn.Execute strSQL
cn.Close


    Endtime = CInt((TimeValue(Now()) - TimeValue(Bigintime)) * 24 * 60 * 60)
    Debug.Print addcount & "件は" & Endtime & "秒掛かりました"
    
    MsgBox "開始時間：" & Bigintime & chr(10) & _
           "終了時間：" & Now & chr(10) & _
             addcount & "件が成功に処理しました　" & chr(10) & _
             Endtime & "秒掛かりました"
End Sub
Function date_change(cell_date As String) As String
Dim tmpdate As Variant
tmpdate = Split(cell_date, "/")
If Len(tmpdate(1)) < 2 Then
    tmpdate(1) = "0" & tmpdate(1)
End If
If Len(tmpdate(2)) < 2 Then
    tmpdate(2) = "0" & tmpdate(2)
End If
date_change = tmpdate(0) & tmpdate(1) & tmpdate(2)
End Function

Sub ShowWorkTime()
'
' Selection出勤状況
'
Dim TotalHours As Double
Dim WORKHOURS As Double
Dim Vaction As Double
Dim FlexLeave As Double
Dim SickLeave As Double
Dim OtherLeave As Double
Dim Holiday As Double
Dim Training As Double
Dim AllLeave As Double
Dim NoWork As Double

Dim OT As Double
Dim KA As Double
Dim WeekendOT As Double

    
Dim r1 As Range

     Selection.Copy
    
     Set NewSheet = Worksheets.Add
     NewSheet.NAME = "tempXXXX"
     NewSheet.Paste
        
     Set r1 = Sheets("tempXXXX").Cells
    
    WORKHOURS = 0
    WORKHOURS = Application.WorksheetFunction.Sum(r1)

    
    Vaction = 0
    r1.Replace What:="V", Replacement:=""
    Vaction = Application.WorksheetFunction.Sum(r1) - WORKHOURS
    
    FlexLeave = 0
    r1.Replace What:="F", Replacement:=""
    FlexLeave = Application.WorksheetFunction.Sum(r1) - WORKHOURS - Vaction
    
    SickLeave = 0
    r1.Replace What:="S", Replacement:=""
    SickLeave = Application.WorksheetFunction.Sum(r1) - WORKHOURS - Vaction - FlexLeave
    
    OtherLeave = 0
    r1.Replace What:="O", Replacement:=""
    OtherLeave = Application.WorksheetFunction.Sum(r1) - WORKHOURS - Vaction - FlexLeave - SickLeave
    
    Holiday = 0
    r1.Replace What:="H", Replacement:=""
    Holiday = Application.WorksheetFunction.Sum(r1) - WORKHOURS - Vaction - FlexLeave - SickLeave - OtherLeave
    
    AllLeave = Vaction + FlexLeave + SickLeave + OtherLeave + Holiday
    
    Training = 0
    r1.Replace What:="T", Replacement:=""
    Training = Application.WorksheetFunction.Sum(r1) - WORKHOURS - AllLeave
    
    NoWork = AllLeave + Training
    
    TotalHours = WORKHOURS + AllLeave + Training
  
    Worksheets("tempXXXX").Cells.Clear
    Application.DisplayAlerts = False
    Worksheets("tempXXXX").Delete
    
   MsgBox "TotalHours：" & TotalHours & "h" & vbCrLf & "WorkHours：" & WORKHOURS & "h" & vbCrLf & "All Leave：" & AllLeave & "h" & vbCrLf & _
  "(H：" & Holiday & "h, V：" & Vaction & "h, F：" & FlexLeave & "h, S：" & SickLeave & "h, O：" & OtherLeave & "h)" & vbCrLf & "Training：" & Training & "h"
    
End Sub
