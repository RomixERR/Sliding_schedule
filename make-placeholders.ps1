<# Генерация временных (placeholder) картинок для календаря.
   Замените полученные файлы своими фотографиями/иконками с теми же именами:
   img\smena\smena1.jpg ... smena4.jpg
   img\shiftend\den.jpg, noch.jpg, otsipnoy.jpg, vihodnoy.jpg
   Запуск:  Get-Content -Raw -Encoding UTF8 make-placeholders.ps1 | Invoke-Expression  #>

Add-Type -AssemblyName System.Drawing

function Save-Jpg($path, $w, $h, $bg, $fg, $text, $sub){
  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g   = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.Clear($bg)

  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment     = [System.Drawing.StringAlignment]::Center
  $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
  $fgBrush = New-Object System.Drawing.SolidBrush $fg

  # подписываем большую надпись так, чтобы она гарантированно помещалась
  $size = 46
  while ($size -gt 8){
    $font = New-Object System.Drawing.Font("Segoe UI", $size, [System.Drawing.FontStyle]::Bold)
    $sz   = $g.MeasureString($text, $font)
    if ($sz.Width -lt ($w - 12) -and $sz.Height -lt ($h * 0.62)){ break }
    $font.Dispose(); $size -= 2
  }
  $font = New-Object System.Drawing.Font("Segoe UI", $size, [System.Drawing.FontStyle]::Bold)
  $g.DrawString($text, $font, $fgBrush, (New-Object System.Drawing.RectangleF(0, 0, $w, ($h * 0.7))), $sf)

  if ($sub){
    $fSub = New-Object System.Drawing.Font("Segoe UI", [Math]::Max(10, [int]($w * 0.11)))
    $g.DrawString($sub, $fSub, $fgBrush, (New-Object System.Drawing.RectangleF(0, ($h * 0.62), $w, ($h * 0.38))), $sf)
  }

  $g.Dispose(); $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Jpeg); $bmp.Dispose()
}

$smenaDir = "img\smena"; $shiftDir = "img\shiftend"
New-Item -ItemType Directory -Force -Path $smenaDir, $shiftDir | Out-Null

$C = { param($r,$g,$b) [System.Drawing.Color]::FromArgb($r,$g,$b) }

# ---- фото смен (заменить реальными фотографиями!) ----
Save-Jpg "$smenaDir\smena1.jpg" 200 200 (& $C 214 232 248) (& $C  25  50  80) "СМЕНА 1" "Вася"
Save-Jpg "$smenaDir\smena2.jpg" 200 200 (& $C 224 240 220) (& $C  25  70  40) "СМЕНА 2" "Петя"
Save-Jpg "$smenaDir\smena3.jpg" 200 200 (& $C 248 224 232) (& $C  95  30  50) "СМЕНА 3" "Люба"
Save-Jpg "$smenaDir\smena4.jpg" 200 200 (& $C 245 234 208) (& $C  80  60  15) "СМЕНА 4" "Семён"

# ---- выходы смен (иконки) ----
Save-Jpg "$shiftDir\den.jpg"      140 140 (& $C 255 214 110) (& $C  90  55   0) "ДЕНЬ"  ""
Save-Jpg "$shiftDir\noch.jpg"     140 140 (& $C  52  82 128) (& $C 235 242 255) "НОЧЬ"  ""
Save-Jpg "$shiftDir\otsipnoy.jpg" 140 140 (& $C 196 196 196) (& $C  45  45  45) "ОТСЫП" ""
Save-Jpg "$shiftDir\vihodnoy.jpg" 140 140 (& $C 214 238 210) (& $C  28  75  35) "ВЫХОД" ""

Write-Host "Placeholder картинки обновлены: $smenaDir и $shiftDir"
