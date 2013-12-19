<%@ Page Title="Local Deals" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DealsInMyArea.aspx.cs" Inherits="Default_DealsInMyArea" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script type="text/javascript">
        $("#CitiesDDL").change(function () {

            PageMethods.ChangeCity($("#CitiesDDL").val(), onSuccess, onFail);
        });

        function onSuccess(data) {
            $("#Deals").html(data);
            $("#Location").text($("#CitiesDDL").val());
        }

        function onFail(error) {
            $("#ErrorMessage").text("We're sorry, but something's gone wrong. Please contact us using the button above, and retain the following error message: ") + error._message;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Deals in <strong id="Location"><%: City %>, <%: Province %></strong></h1>
    <p>Want to see great deals in another city? Pick one from the drop-down below!</p>
    <asp:DropDownList ID="CitiesDDL" runat="server" ClientIDMode="Static" AutoPostBack="true">
        <asp:ListItem Text="Select a City"></asp:ListItem>
    </asp:DropDownList>
    <asp:Label ID="NoCitiesLabel" runat="server"></asp:Label>
    <p id="ErrorMessage"></p>
    <div id="Deals">
        <% Response.Write(CouponsForGiving.HttpRendering.ListMerchantOffers(DIs)); %>
    </div>
</asp:Content>