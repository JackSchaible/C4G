<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DateControl.ascx.cs" Inherits="Controls_DateControl" %>
<script type="text/javascript">
    document.getElementById('<%: this.ClientID %>MonthDDL")').addEventListener('change', changeDays, false);
    document.getElementById('<%: this.ClientID %>YearDDL")').addEventListener('change', changeDays, false);

    function changeDay() {
        var month = Number($("#<%: this.ClientID %>MonthDDL option:selected").val());
        var year = Number($("#<%: this.ClientID %>YearDDL option:selected").val());
        $("#<%: this.ClientID %>DayDDL").html('');

        for (var i = 0; i < getDays(month, year) ; i++) {
            $("#<%: this.ClientID %>DayDDL").append('<option value=' + i + '>' + i + '</option>');
        }
    }

    function getDays(month, year) {
        return new Date(year, month, 0).getDate();
    }
</script>
<div id="<%: this.ID %>">
    <asp:DropDownList ID="DayDDL" runat="server" ClientIDMode="Static"></asp:DropDownList>
    <asp:DropDownList ID="MonthDDL" runat="server" ClientIDMode="Static"></asp:DropDownList>
    <asp:DropDownList ID="YearDDL" runat="server" ClientIDMode="Static"></asp:DropDownList>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
</div>