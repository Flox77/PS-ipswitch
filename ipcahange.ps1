
#Set-ExecutionPolicy Unrestricted -force

$ipadresse = ""
$NetzwerkAdapter = ""
$NetzwerkAdapter_ifIndex = 0
$newsubnet = 24
$newgateway = "192.168.1.1"

#GUI
Add-Type -assembly System.Windows.Forms

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='IP-Adresse wechseln'

$main_form.AutoSize = $true
$main_form.Width = 400
$main_form.Height = 400

#GUI Label
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Netzwerkkarten:"
$Label.Location  = New-Object System.Drawing.Point(10,10)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)
#----

#DropDown Liste
$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Width = 200



#Anzeige der IP und des Namens
$Label_IPAnzeige = New-Object System.Windows.Forms.Label
$Label_IPAnzeige.Location  = New-Object System.Drawing.Point(10,50)
$Label_IPAnzeige.AutoSize = $true

#checkbox delete add
$Checkbox_delete = New-Object System.Windows.Forms.Checkbox 
$Checkbox_delete.Location = New-Object System.Drawing.Size(10,100) 
$Checkbox_delete.Size = New-Object System.Drawing.Size(80,20)
$Checkbox_delete.Text = "delete"
$Checkbox_delete.AutoSize = $true
#$objTypeCheckbox.TabIndex = 4

$Checkbox_add = New-Object System.Windows.Forms.Checkbox 
$Checkbox_add.Location = New-Object System.Drawing.Size(10,130) 
$Checkbox_add.Size = New-Object System.Drawing.Size(80,20)
$Checkbox_add.Text = "add"
$Checkbox_add.AutoSize = $true
$Checkbox_add.Checked= $true
#$objTypeCheckbox.TabIndex = 4

#bei klicken auf delete wird Add gelöscht
$Checkbox_delete.Add_Click({

    If ($Checkbox_delete.Checked)
      {$Checkbox_add.Checked = $false}
})
#bei klicken auf add wird delete gelöscht
$Checkbox_add.Add_Click({
    If ($Checkbox_add.Checked)
      {$Checkbox_delete.Checked = $false}
})

#-----

#Eingabefeld IP Adresse
$IPAdress_Input = New-Object System.Windows.Forms.TextBox
$IPAdress_Input.Location = New-Object System.Drawing.Size(100,110)
$IPAdress_Input.Size = New-Object System.Drawing.Size(260,20)


#Button ändern
$Button =  New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(100,200)
$Button.Size = New-Object System.Drawing.Size(200,20)
$Button.Text = "Ändern"
$Button.Add_Click({
$NetzwerkAdapter.ifIndex
    If ($Checkbox_delete.Checked) {
        #IP entfernen#
        Remove-NetIPAddress -IPAddress $ipadresse.IPAddress

        #IP Adresse hinzufühgen
       # New-NetIPAddress -InterfaceIndex $NetzwerkAdapter_ifIndex -IPAddress $IPAdress_Input.text -PrefixLength $newsubnet -DefaultGateway $newgateway
    }

    If ($Checkbox_add.Checked) {
        #IP Adresse hinzufühgen

        $NetzwerkAdapter = Get-NetAdapter | Where-Object Name -like $combobox.text| select-object -Property ifIndex 

       # New-NetIPAddress -InterfaceIndex $NetzwerkAdapter.ifIndex -IPAddress $IPAdress_Input.text -PrefixLength $newsubnet -DefaultGateway $newgateway
    }
})

#DropDown füllen
$Netzwerkkarten = Get-NetAdapter | select-object -Property Name,ifIndex 
Foreach ($Netzwerkkarte in $Netzwerkkarten) {
 $ComboBox.Items.Add($Netzwerkkarte.Name);
}
#$ComboBox.add
$ComboBox.add_SelectedIndexChanged($ComboBox_SelectedIndexChanged)

$ComboBox.Location  = New-Object System.Drawing.Point(150,10)
$main_form.Controls.Add($ComboBox)

#Bei Änderung des dropDown
$ComboBox_SelectedIndexChanged = {
    Write-host "test"
    #Name und ID des gewählten Interface 
    $NetzwerkAdapter = Get-NetAdapter | Where-Object Name -like $combobox.text| select-object -Property Name,ifIndex 
    $NetzwerkAdapter_ifIndex = $NetzwerkAdapter.ifIndex
    #IP Adressse des Interface ermitteln
    $ipadresse = Get-NetIPAddress | Where-Object InterfaceIndex -match $NetzwerkAdapter.ifIndex| select-object -Property IPAddress,InterfaceIndex

    #Write-host $NetzwerkAdapter_ifIndex
    #$dataGrid.Rows.Add($combobox.text,$ipadresse.IPAddress)
    #$main_form.Controls.Add($dataGrid)

    #Anzeige IP und Karte
    $Label_IPAnzeige.Text = ""
    $Label_IPAnzeige.Text = $combobox.text + ": " + $ipadresse.IPAddress
    $main_form.Controls.Add($Label_IPAnzeige)

    #Checkbox
    $main_form.Controls.Add($Checkbox_delete)
    $main_form.Controls.Add($Checkbox_add)

    #Eingange IP
    $main_form.Controls.Add($IPAdress_Input)

    #Button
    $main_form.Controls.Add($Button)
    
}

#---

#$dataGrid = New-Object System.Windows.Forms.DataGridView 
#$dataGrid.Size=New-Object System.Drawing.Size(400,100)
#$dataGrid.Location = New-Object System.Drawing.Point(10,100)
#$dataGrid.ColumnCount = 2
#$dataGrid.ColumnHeadersVisible = $true
#$dataGrid.Columns[0].Name = "Netzwerkkarte"
#$dataGrid.Columns[1].Name = "IP-Adresse"




#GUI Anzeigen
$main_form.ShowDialog()


