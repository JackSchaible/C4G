<%@ Page Title="Legal Agreements" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="LegalAgreements.aspx.cs" Inherits="LegalAgreements" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
    <h1>Legal Agreements</h1>
    <h2>General</h2>
    <ul>
        <li>
            <a href="Content/Terms/TermsOfUse.pdf">Terms Of Use</a>
            <iframe src="Content/Terms/TermsOfUse.txt"></iframe>
        </li>
        <li>
            <a href="Content/Terms/Privacy Policy.pdf">Privacy Policy</a>
            <iframe src="Content/Terms/PrivacyPolicy.txt"></iframe>
        </li>
    </ul>
    <h2>Merchant</h2>
    <ul>
        <li>
            <a href="Content/Terms/MerchantServicesAgreement.pdf">Merchant Services Agreement</a>
            <iframe src="Content/Terms/MerchantServicesAgreement.txt"></iframe>
        </li>
    </ul>
    <h2>Not-For-Profit</h2>
    <ul>
        <li>
            <a href="Content/Terms/NPOServicesAgreement.pdf">NPO Services Agreement</a>
            <iframe src="Content/Terms/NPOServicesAgreement.txt"></iframe>
        </li>
    </ul>
</asp:Content>