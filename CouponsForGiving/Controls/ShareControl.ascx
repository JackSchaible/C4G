<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ShareControl.ascx.cs" Inherits="Controls_SocialShare" %>
    <script type="text/javascript">
        function shareOnFB() {
            FB.login(function (response) {
                if (response.authResponse) {
                    FB.ui({
                        display: 'iframe',
                        method: 'feed',
                        link: '<%: URL %>',
                        picture: '<%: ImageURL %>',
                        caption: '<%: Caption %>',
                        name: '<%: Name %> - C4G',
                        description: '<%: Description %>',
                    },
                    function (response) {
                        if (response && response.post_id) {
                        }
                        else {
                            $("#FBMsg").val("Something went wrong. Your campaign was not shared.");
                        }
                    });
                }
                else {
                    $("#FBMsg").val("You must log in to Facebook in order to post your campaign there.");
                }
            });
        }

        function shareOnLinkedIn() {
            var xml = "<share><comment><%: Caption%></comment><content><title><%: Name %> - C4G</title><description><%: Description%></description><submitted-url><%: URL %></submitted-url><submitted-image-url><%: ImageURL %></submitted-image-url></content><visibility><code>anyone</code></visibility></share>";
            $.ajax({
                type: "POST",
                url: "http://api.linkedin.com/v1/people/~/shares",
                data: xml,
                success: function () {
                    alert();
                },
                dataType : "xml"
            })
            .fail(function () {
                alert("Fail");
            });
        }
    </script>
    <script src="https://platform.linkedin.com/in.js" type="text/javascript">
        lang: en_US
        api_key: <%: System.Web.Configuration.WebConfigurationManager.AppSettings["LinkedIn_API_Key"] %>
        authorize: true
    </script>
    <div id="SocialStuff">
        <h2>Share on Social Media</h2>
        <p>URL <%: URL %></p>
        <p class="btn" onclick="shareOnFB()">Share on Facebook</p>
        <div class="fb-like" data-href="<%: URL %>"
             data-layout="button" data-action="like" data-show-faces="true" data-share="false"></div>
        <p id="FBMsg"></p>
        <a href="https://twitter.com/share" class="twitter-share-button"
            data-text="<%: Caption %>" data-hashtags="C4G, DealsThatMakeADifference">Tweet</a>
        <p onclick="shareOnLinkedIn()">Share on LinkedIn</p>
    </div>
