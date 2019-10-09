<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PostToFB.aspx.cs" Inherits="PostToFacebook.PostToFB" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Post to Facebook Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input type="text" value="Hey, there! Post me to FB page." name="message" id="message" />
            <input type="button" value="POST" onclick="FBLogin()" />
        </div>
    </form>
    <script>

        window.fbAsyncInit = function () {
            FB.init({
                appId: 'xxxxxxxxx', //change your facebook app id that will authorize page managers...
                status: true,
                cookie: true,
                xfbml: true,
                oauth: true
            });
        };

        (function (d) {
            var js, id = 'facebook-jssdk'; if (d.getElementById(id)) { return; }
            js = d.createElement('script'); js.id = id; js.async = true;
            js.src = "//connect.facebook.net/en_US/all.js";
            d.getElementsByTagName('head')[0].appendChild(js);
        }(document));

        function FBLogin() {
            FB.getLoginStatus(function (response) {
                if (response.status === 'connected') {
                    var page_id = 'xxxxxxxxx'; //change your facebook page id that you want to post messages...
                    var message = document.getElementById("message").value;
                    //var photo = "https://unsplash.com/photos/-22C5tv2hyY";
                    FB.api('/me/accounts', function (response) {
                        for (var i = 0; i < response.data.length - 1; i++) {
                            if (response.data[i].id == page_id) {
                                postToPage(response.data[i], message);
                                //photoToPage(response.data[i], photo, message)
                                return;
                            }
                        }
                    });
                }
                else {
                    FB.login(function () { }, { scope: 'publish_actions, manage_pages, publish_pages' });
                    FBLogin();
                }
            });
        }

        function postToPage(page, message) {
            FB.api('/' + page.id + '/feed', 'post', { message: message, access_token: page.access_token },
              function (res) { console.log(JSON.stringify(res)); }
            )
        }

        function photoToPage(page, photo, message) {
            FB.api('/' + page.id + '/photos', 'post', { url: photo, message: message, access_token: page.access_token },
              function (res) { console.log(JSON.stringify(res)); }
            );
        }
    </script>
</body>
</html>
