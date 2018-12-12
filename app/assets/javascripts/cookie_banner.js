document.addEventListener('DOMContentLoaded', function() {
    if (document.cookie.replace(/(?:(?:^|.*;\s*)seen_cookie_message\s*\=\s*([^;]*).*$)|^.*$/, "$1") !== "true") {
        document.getElementById('cookie_banner').style.display = 'block';
        document.cookie = "seen_cookie_message=true; expires=Fri, 31 Dec 9999 23:59:59 GMT";
    }
});
