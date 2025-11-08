class AppApi{
  static const baseUrlProd = "http://localhost:8000";
  static const version = "v1";
  static const register = "/auth/register";
  static const login = "/auth/login";
  static const logout = "/auth/logout";
  static const passwordReset = "/auth/password-reset";
  static const totpEnable = "/auth/enable-totp";
  static const totpConfirm = "/auth/confirm-totp";
  static const totpDisable = "/auth/disable-totp";
  static const totpStatus = "/auth/totp-status";
  static const me = "/auth/me";
  static const rToken = "/auth/refresh";
  static const profileImage = "/auth/profile-image";
  static const transactions = "/transactions";
  static const accounts = "/accounts";
  static const categories = "/categories";
  static const goals = "/goals";

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
