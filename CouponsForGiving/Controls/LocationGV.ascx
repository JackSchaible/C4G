<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LocationGV.ascx.cs" Inherits="Controls_LocationGV" %>
<asp:DropDownList ID="CountriesDDL" runat="server" DataSourceID="CountriesEDS" DataTextField="Name" DataValueField="CountryCode" OnSelectedIndexChanged="CountriesDDL_SelectedIndexChanged"></asp:DropDownList>
<asp:DropDownList ID="ProvinceDDL" runat="server"></asp:DropDownList>
<asp:GridView ID="CitiesGV" runat="server"></asp:GridView>
<asp:Label ID="Selected" runat="server" Text=""></asp:Label>