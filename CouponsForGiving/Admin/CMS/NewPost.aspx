<%@ Page Title="New Post" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="NewPost.aspx.cs" Inherits="Admin_CMS_NewPost" %>
<%@ Reference Control="~/Controls/MenuBar.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BannerContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Main_Content" Runat="Server">
    <script type="text/javascript">
        function save() {
            var title = $("#title").val();
            var content = $("#content").val();

            PageMethods.Save(title, content, onSuccess, onError);        
        }

        function onSuccess() {
            $("#Errors").text("Your post has been uploaded successfully!");
        }

        function onError(error) {
            $("#Errors").text(error._message)
        }
    </script>
    <h1>New <strong>In The Community</strong> Post</h1>
    <div class="Form">
        <div class="FormRow">
            <p id="Errors"></p>
        </div>
        <div class="FormRow">
            <label>Name</label>
            <asp:TextBox ID="NameTextBox" runat="server"></asp:TextBox>
        </div>
        <div id="ContentRow">
            <label>Content</label>
             <asp:TextBox runat="server"
        ID="txtBox1" 
        TextMode="MultiLine" 
        Columns="50" 
        Rows="10" 
        Text="Hello <b>world!</b>" />
    
    <ajaxToolkit:HtmlEditorExtender 
        ID="htmlEditorExtender1" 
        TargetControlID="txtBox1" 
        runat="server" 
        EnableSanitization="false">            
    </ajaxToolkit:HtmlEditorExtender>
        </div>
        <div class="FormRow">
            <button class="btn-center" onclick="savePost()">Post</button>
        </div>
    </div>
</asp:Content>