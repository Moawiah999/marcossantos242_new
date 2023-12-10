// ignore_for_file: constant_identifier_names

/*
|--------------------------------------------------------------------------
| request response codes (standard):
|--------------------------------------------------------------------------
*/

const SUCCESS_MSG = 'success';

const NO_RESULTS_MSG = 'no_results';

const PRIVATE_RESULTS_MSG = 'private_results';

const END_OF_RESULTS_MSG = 'end_of_results';

const ERROR_BAD_REQUEST_MSG = 'error_bad_request';

// sent when something went wrong on server
const ERROR_FAILED_REQUEST_MSG = 'error_failed_request';

const ERROR_NON_SUPPORTED_REQUEST_MSG = 'non_supported_request';

/*
|--------------------------------------------------------------------------
| session related:
|--------------------------------------------------------------------------
*/

const D_ERROR_SESSION_UNAUTHORIZED_MSG = 'd_error_session_unauthorized';

const D_ERROR_SESSION_REQUIRES_EMAIL_VERIFICATION = 'd_error_session_requires_email_verification';

/*
|--------------------------------------------------------------------------
| user:
|--------------------------------------------------------------------------
*/

const D_ERROR_USER_NOT_FOUND_MSG = 'd_error_user_not_found';

const D_ERROR_USER_NOT_MATCHED_MSG = 'd_error_user_not_matched';

const D_ERROR_USER_MISSING_FIELDS_MSG = 'd_error_user_missing_fields';

// username

const D_ERROR_USER_USERNAME_NOT_AVAILABLE_MSG = 'd_error_user_username_not_available';

const D_ERROR_USER_USERNAME_STARTS_WITH_ALHPABET_MSG = 'd_error_user_username_starts_with_alhpabet';

const D_ERROR_USER_USERNAME_ALLOWED_CHARACTERS_ONLY_MSG = 'd_error_user_username_allowed_characters_only';

// email

const D_ERROR_USER_EMAIL_NOT_AVAILABLE_MSG = 'd_error_user_email_not_available';

const D_ERROR_USER_EMAIL_INVALID_FORMAT_MSG = 'd_error_user_email_invalid_format';

// display web

const D_ERROR_USER_DISPLAY_WEB_INVALID_FORMAT_MSG = 'd_error_user_display_web_invalid_format';

// password

const D_ERROR_USER_PASSWORD_MISMATCH_MSG = 'd_error_user_password_mismatch';

// display image

const D_ERROR_USER_DISPLAY_IMAGE_FILE_SIZE_MSG = 'd_error_user_display_image_file_size';

const D_ERROR_USER_DISPLAY_IMAGE_FILE_FORMAT_MSG = 'd_error_user_display_image_file_format';

// length related

const D_ERROR_USER_USERNAME_MAX_LEN_MSG = 'd_error_user_username_max_len';

const D_ERROR_USER_USERNAME_MIN_LEN_MSG = 'd_error_user_username_min_len';

const D_ERROR_USER_PASSWORD_MAX_LEN_MSG = 'd_error_user_password_max_len';

const D_ERROR_USER_PASSWORD_MIN_LEN_MSG = 'd_error_user_password_min_len';

const D_ERROR_USER_EMAIL_MAX_LEN_MSG = 'd_error_user_email_max_len';

const D_ERROR_USER_EMAIL_MIN_LEN_MSG = 'd_error_user_email_min_len';

const D_ERROR_USER_DISPLAY_NAME_MAX_LEN_MSG = 'd_error_user_display_name_max_len';

const D_ERROR_USER_DISPLAY_NAME_MIN_LEN_MSG = 'd_error_user_display_name_min_len';

const D_ERROR_USER_DISPLAY_BIO_MAX_LEN_MSG = 'd_error_user_display_bio_max_len';

const D_ERROR_USER_DISPLAY_BIO_MIN_LEN_MSG = 'd_error_user_display_bio_min_len';

const D_ERROR_USER_DISPLAY_WEB_MAX_LEN_MSG = 'd_error_user_display_web_max_len';

const D_ERROR_USER_DISPLAY_WEB_MIN_LEN_MSG = 'd_error_user_display_web_min_len';

// user recovery

const D_ERROR_OTP_EXPIRED = 'd_error_otp_expired';

const D_ERROR_OTP_MISMATCH = 'd_error_otp_mismatch';

/*
|--------------------------------------------------------------------------
| post
|--------------------------------------------------------------------------
*/

// display content item

const D_ERROR_POST_DISPLAY_CONTENT_ITEM_FILE_SIZE_MSG = 'd_error_post_display_content_item_file_size';

const D_ERROR_POST_DISPLAY_CONTENT_ITEM_FILE_FORMAT_MSG = 'd_error_post_display_content_item_file_format';

// length

const D_ERROR_POST_DISPLAY_CAPTION_MAX_LEN_MSG = 'd_error_post_display_caption_max_len';

const D_ERROR_POST_DISPLAY_CAPTION_MIN_LEN_MSG = 'd_error_post_display_caption_min_len';

const D_ERROR_POST_DISPLAY_LOCATION_MAX_LEN_MSG = 'd_error_post_display_location_max_len';

const D_ERROR_POST_DISPLAY_LOCATION_MIN_LEN_MSG = 'd_error_post_display_location_min_len';

const D_ERROR_POST_DISPLAY_CONTENT_ITEM_MAX_MSG = 'd_error_post_display_content_item_max';

const D_ERROR_POST_DISPLAY_CONTENT_ITEM_MIN_MSG = 'd_error_post_display_content_item_min';

const D_ERROR_POST_HASHTAG_MAX_MSG = 'd_error_post_hashtag_max';

const D_ERROR_POST_HASHTAG_MIN_MSG = 'd_error_post_hashtag_min';

const D_ERROR_POST_HASHTAG_MAX_LEN_MSG = 'd_error_post_hashtag_max_len';

const D_ERROR_POST_HASHTAG_MIN_LEN_MSG = 'd_error_post_hashtag_min_len';

const D_ERROR_POST_USER_TAG_PER_ITEM_MAX = 'd_error_post_user_tag_per_item_max';

const D_ERROR_POST_USER_TAG_PER_ITEM_MIN = 'd_error_post_user_tag_per_item_min';

const D_ERROR_POST_USER_TAG_TOTAL_MAX = 'd_error_post_user_tag_total_max';

const D_ERROR_POST_USER_TAG_TOTAL_MIN = 'd_error_post_user_tag_total_min';

/*
|--------------------------------------------------------------------------
| post comment
|--------------------------------------------------------------------------
*/

// length

const D_ERROR_POST_COMMENT_DISPLAY_TEXT_MAX_LEN_MSG = 'd_error_post_comment_display_text_max_len';

const D_ERROR_POST_COMMENT_DISPLAY_TEXT_MIN_LEN_MSG = 'd_error_post_comment_display_text_min_len';

/*
|--------------------------------------------------------------------------
| collection
|--------------------------------------------------------------------------
*/

// length

const D_ERROR_COLLECTION_DISPLAY_TITLE_MAX_LEN_MSG = 'd_error_collection_display_title_max_len';

const D_ERROR_COLLECTION_DISPLAY_TITLE_MIN_LEN_MSG = 'd_error_collection_display_title_min_len';

/*
|--------------------------------------------------------------------------
| misc/system
|--------------------------------------------------------------------------
*/

const ENTITY_IN_USE_MSG = 'entity_in_use'; // Not availabe

const ENTITY_UNAUTHORIZED_MSG = 'entity_unauthorized'; // Not allowed

const ENTITY_FORBIDDEN_MSG = 'entity_forbidden'; // Banned

const ENTITY_NOT_FOUND_MSG = 'entity_not_found';       // Available
