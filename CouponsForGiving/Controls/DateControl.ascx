﻿<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DateControl.ascx.cs" Inherits="Controls_DateControl" %>
<div id="<%: this.ID %>">
    <asp:DropDownList ID="DayDDL" runat="server" ClientIDMode="Static"></asp:DropDownList>
    <asp:DropDownList ID="MonthDDL" runat="server" ClientIDMode="Static"></asp:DropDownList>
    <asp:DropDownList ID="YearDDL" runat="server" ClientIDMode="Static"></asp:DropDownList>
    <asp:Label ID="ErrorLabel" runat="server"></asp:Label>
</div>