<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DateControl.ascx.cs" Inherits="Controls_DateControl" %>
<script type="text/javascript">
    function changeDay() {
        var month = $("[id$='<%: this.ID %>$MonthDDL']").find(':selected').val();
        var year = Number($("[id$='<%: this.ID %>$YearDDL'] option:selected").val());
        $("[id$='<%: this.ID %>$DayDDL']").html('asd');
        
        console.log(month);

        for (var i = 0; i < getDays(month, year) ; i++) {
            $("[id$='<%: this.ID %>$DayDDL']").append('<option value=' + i + '>' + i + '</option>');
        }
    }

    function getDays(month, year) {
        return new Date(year, month, 0).getDate();
    }
</script>
<div id="<%: this.ID %>">
    <asp:DropDownList ID="DayDDL" runat="server" ClientIDMode="Static"></asp:DropDownList>
    <asp:DropDownList ID="MonthDDL" runat="server" ClientIDMode="Static" onchange="changeDay()"></asp:DropDownList>
    <asp:DropDownList ID="YearDDL" runat="server" ClientIDMode="Static" onchange="changeDay()"></asp:DropDownList>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
</div>