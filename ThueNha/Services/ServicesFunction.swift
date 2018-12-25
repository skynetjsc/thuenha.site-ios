
enum APIFunction : String
{
    case loginEGovUser                      = "/api/authenticate/Login"                         //Đăng nhập app
    case get_info                           = "/api/get_info.php"   // Chi tiết người đăng
    case post_detail                        = "/api/post_detail.php" // chi tiết đăng tin
    case delete_post                        = "/api/delete_post.php"
    case pay_view                           = "/api/pay_view.php" // trả tiền xem tin
    
}


extension Services
{
}

