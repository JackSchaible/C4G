<%@ Page Title="My Settings" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Settings.aspx.cs" Inherits="Merchant_MyPartners_Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main_Content" Runat="Server">
    <style type="text/css">
        .Form {
            margin: 0;
            width: 50%;
        }
        .FormRow {
            padding: 0 0 0 15%;
        }
    </style>
    <h1>Settings</h1>
    <div class="Form">
        <p>Requests</p>
        <div class="FormRow">
            <a ID="SHRequestSettingsPanel" runat="server">Show/Hide</a>
            <asp:Panel ID="RequestSettingsPanel" runat="server">
            <asp:Label ID="Label1" runat="server" Text="Auto-Approve All Requests"></asp:Label><asp:CheckBox ID="AutoApproveCheckBox" runat="server" />
            </asp:Panel>
            <ajaxToolkit:CollapsiblePanelExtender ID="ReuqestsSettingsPanelCPE" CollapseControlID="SHRequestSettingsPanel" 
                ExpandControlID="SHRequestSettingsPanel" TargetControlID="RequestSettingsPanel" runat="server" Enabled="True"
                CollapsedText="Request Settings">
            </ajaxToolkit:CollapsiblePanelExtender>
        </div>
        <div class="FormRow">
            <asp:Button ID="SaveButton" runat="server" Text="Save" />
        </div>
    </div>
</asp:Content>