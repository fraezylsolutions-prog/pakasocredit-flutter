import 'package:flutter/foundation.dart';

class UserModel {
  int? id;
  int? portfolioId;
  int? branchId;
  String? portfolios;
  String? avatar;
  String? firstName;
  String? lastName;
  String? country;
  String? phone;
  String? username;
  String? email;
  String? gender;
  String? dateOfBirth;
  String? city;
  String? zipCode;
  String? address;
  double? balance;
  int? points;
  int? status;
  String? closeReason;
  int? refId;
  String? accountNumber;
  int? kyc;
  String? kycCredential;
  bool? twoFa;
  int? depositStatus;
  int? withdrawStatus;
  int? transferStatus;
  int? otpStatus;
  int? dpsStatus;
  int? fdrStatus;
  int? loanStatus;
  int? payBillStatus;
  int? portfolioStatus;
  int? rewardStatus;
  int? referralStatus;
  String? emailVerifiedAt;
  NotificationsPermission? notificationsPermission;
  String? passcode;
  bool? phoneVerified;
  String? otp;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? fullName;
  String? kycTime;
  String? kycType;
  String? totalProfit;
  String? totalDeposit;
  String? avatarPath;
  bool? twoFaIntitialized;
  bool? isUnreadNotification;
  String? twoFaQrCode;

  UserModel({
    this.id,
    this.portfolioId,
    this.branchId,
    this.portfolios,
    this.avatar,
    this.firstName,
    this.lastName,
    this.country,
    this.phone,
    this.username,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.city,
    this.zipCode,
    this.address,
    this.balance,
    this.points,
    this.status,
    this.closeReason,
    this.refId,
    this.accountNumber,
    this.kyc,
    this.kycCredential,
    this.twoFa,
    this.depositStatus,
    this.withdrawStatus,
    this.transferStatus,
    this.otpStatus,
    this.dpsStatus,
    this.fdrStatus,
    this.loanStatus,
    this.payBillStatus,
    this.portfolioStatus,
    this.rewardStatus,
    this.referralStatus,
    this.emailVerifiedAt,
    this.notificationsPermission,
    this.passcode,
    this.phoneVerified,
    this.otp,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.fullName,
    this.kycTime,
    this.kycType,
    this.totalProfit,
    this.totalDeposit,
    this.avatarPath,
    this.twoFaIntitialized,
    this.isUnreadNotification,
    this.twoFaQrCode,
  });

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString());
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    final s = v.toString().toLowerCase();
    return s == "1" || s == "true" || s == "yes";
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) print("USER_JSON: $json");
    try {
      final user = UserModel();
      user.id = _toInt(json['id']);
      user.portfolioId = _toInt(json['portfolio_id']);
      user.branchId = _toInt(json['branch_id']);
      user.portfolios = json['portfolios']?.toString();
      user.avatar = json['avatar']?.toString();
      user.firstName = json['first_name']?.toString();
      user.lastName = json['last_name']?.toString();
      user.country = json['country']?.toString();
      user.phone = json['phone']?.toString();
      user.username = json['username']?.toString();
      user.email = json['email']?.toString();
      user.gender = json['gender']?.toString();
      user.dateOfBirth = json['date_of_birth']?.toString();
      user.city = json['city']?.toString();
      user.zipCode = json['zip_code']?.toString();
      user.address = json['address']?.toString();
      user.balance = _toDouble(json['balance']);
      user.points = _toInt(json['points']);
      user.status = _toInt(json['status']);
      user.closeReason = json['close_reason']?.toString();
      user.refId = _toInt(json['ref_id']);
      user.accountNumber = json['account_number']?.toString();
      user.kyc = _toInt(json['kyc']);
      user.kycCredential = json['kyc_credential']?.toString();
      user.twoFa = _toBool(json['two_fa']);
      user.depositStatus = _toInt(json['deposit_status']);
      user.withdrawStatus = _toInt(json['withdraw_status']);
      user.transferStatus = _toInt(json['transfer_status']);
      user.otpStatus = _toInt(json['otp_status']);
      user.dpsStatus = _toInt(json['dps_status']);
      user.fdrStatus = _toInt(json['fdr_status']);
      user.loanStatus = _toInt(json['loan_status']);
      user.payBillStatus = _toInt(json['pay_bill_status']);
      user.portfolioStatus = _toInt(json['portfolio_status']);
      user.rewardStatus = _toInt(json['reward_status']);
      user.referralStatus = _toInt(json['referral_status']);
      user.emailVerifiedAt = json['email_verified_at']?.toString();
      
      if (json['notifications_permission'] != null) {
        try {
           user.notificationsPermission = NotificationsPermission.fromJson(Map<String, dynamic>.from(json['notifications_permission']));
        } catch (e) {
          if (kDebugMode) print("NotificationsPermission parse error: $e");
        }
      }
      
      user.passcode = json['passcode']?.toString();
      user.phoneVerified = _toBool(json['phone_verified']);
      user.otp = json['otp']?.toString();
      user.createdAt = json['created_at']?.toString();
      user.updatedAt = json['updated_at']?.toString();
      user.deletedAt = json['deleted_at']?.toString();
      user.fullName = json['full_name']?.toString();
      user.kycTime = json['kyc_time']?.toString();
      user.kycType = json['kyc_type']?.toString();
      user.totalProfit = json['total_profit']?.toString();
      user.totalDeposit = json['total_deposit']?.toString();
      user.avatarPath = json['avatar_path']?.toString();
      user.twoFaIntitialized = _toBool(json['2fa_intitialized']);
      user.isUnreadNotification = _toBool(json['is_unread_notification']);
      user.twoFaQrCode = json['2fa_qr_code']?.toString();
      
      return user;
    } catch (e, stack) {
      if (kDebugMode) {
        print("UserModel parsing error: $e");
        print(stack);
      }
      return UserModel();
    }
  }
}

class NotificationsPermission {
  bool? b2faNotifications;
  bool? allPushNotifications;
  bool? dpsEmailNotificaitons;
  bool? fdrEmailNotificaitons;
  bool? loanEmailNotificaitons;
  bool? depositEmailNotificaitons;
  bool? supportEmailNotificaitons;
  bool? payBillEmailNotificaitons;
  bool? referralEmailNotificaitons;
  bool? portfolioEmailNotificaitons;
  bool? fundTransferEmailNotificaitons;
  bool? rewardsRedeemEmailNotificaitons;
  bool? withdrawPaymentEmailNotificaitons;

  NotificationsPermission({
    this.b2faNotifications,
    this.allPushNotifications,
    this.dpsEmailNotificaitons,
    this.fdrEmailNotificaitons,
    this.loanEmailNotificaitons,
    this.depositEmailNotificaitons,
    this.supportEmailNotificaitons,
    this.payBillEmailNotificaitons,
    this.referralEmailNotificaitons,
    this.portfolioEmailNotificaitons,
    this.fundTransferEmailNotificaitons,
    this.rewardsRedeemEmailNotificaitons,
    this.withdrawPaymentEmailNotificaitons,
  });

  static bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    final s = v.toString().toLowerCase();
    return s == "1" || s == "true" || s == "yes";
  }

  factory NotificationsPermission.fromJson(Map<String, dynamic> json) {
    return NotificationsPermission(
      b2faNotifications: _toBool(json['2fa_notifications']),
      allPushNotifications: _toBool(json['all_push_notifications']),
      dpsEmailNotificaitons: _toBool(json['dps_email_notificaitons']),
      fdrEmailNotificaitons: _toBool(json['fdr_email_notificaitons']),
      loanEmailNotificaitons: _toBool(json['loan_email_notificaitons']),
      depositEmailNotificaitons: _toBool(json['deposit_email_notificaitons']),
      supportEmailNotificaitons: _toBool(json['support_email_notificaitons']),
      payBillEmailNotificaitons: _toBool(json['pay_bill_email_notificaitons']),
      referralEmailNotificaitons: _toBool(json['referral_email_notificaitons']),
      portfolioEmailNotificaitons: _toBool(json['portfolio_email_notificaitons']),
      fundTransferEmailNotificaitons: _toBool(json['fund_transfer_email_notificaitons']),
      rewardsRedeemEmailNotificaitons: _toBool(json['rewards_redeem_email_notificaitons']),
      withdrawPaymentEmailNotificaitons: _toBool(json['withdraw_payment_email_notificaitons']),
    );
  }
}
