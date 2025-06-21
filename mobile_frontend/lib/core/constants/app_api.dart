class AppApi{
  static const baseUrlProd = "http://localhost:8000";
  static const version = "v1";
  static const register = "/auth/register";
  static const login = "/auth/login";
  static const logout = "/auth/logout";
  static const password_reset = "/auth/password-reset";
  static const totp_enable = "/auth/enable-totp";
  static const totp_confirm = "/auth/confirm-totp";
  static const totp_disable = "/auth/disable-totp";
  static const totp_status = "/auth/totp-status";
  static const me = "/auth/me";
  static const r_token = "/auth/refresh";

  // static const orderStatus = "/order-status";
  // static const regions = "/regions";
  // static const social = "/social";
  // static const createUser = "/auth/create-user";
  // static const auth = "/auth";
  // static const deleteUser = "/auth/delete-user";
  // static const updateUser = "/auth/update-user";
  // static const createOrder = "/order";
  // static const measurement = "/room-meansurement";
  // static const history = "/history";
  // static const statistics = "/statistics";
}
