function Get-Beer{
  
  [xml]$products = Invoke-RestMethod -Uri https://www.systembolaget.se/api/assortment/products/xml
  $Bira= $products.artiklar.artikel |  where {$_.Varugrupp -match "ÖL" }
  $beer = @{}
  $result = @()
  
  foreach ($t in $Bira){
    [datetime]$datum  = $t.Saljstart
    [Int]$pris        = $t.Prisinklmoms
    $namn             = $t.namn
    $leverantor       = $t.Leverantor
    $Ursprunglandnamn = $t.Ursprunglandnamn
    $nr               = $t.nr
    $VaruGrupp        = $t.Varugrupp
    $AlkoholHalt      = $t.Alkoholhalt
    $ArtikelID        = $t.Artikelid
    $typ              = $t.Typ
    $Förpackning      = $t.Forpackning
   
    $beer = @{
      Namn        = $namn 
      Pris        = $pris
      AlkoholHalt = $AlkoholHalt 
      Leveratör   = $leverantor
      typ         = $typ
      Land        = $Ursprunglandnamn
      nr          = $nr
      ArtikelID   = $ArtikelID
      SäljStart   = $datum
      Förpackning = $Förpackning
    }
    
    $result += (New-Object PSObject -Property $beer)
  }

  $result | select namn, pris, alkoholhalt, leveratör, typ, land, nr, artikelid, förpackning, SäljStart #| where {$_.säljstart -gt (Get-Date).AddDays(-31) }
}

Get-Beer | sort AlkoholHalt
