Paperclip::UriAdapter.register
Paperclip::Attachment.default_options.merge!(
  storage: :s3,
  s3_protocol: 'https',
  s3_permissions: :private,
  s3_server_side_encryption: 'AES256',
  s3_region: ENV['AWS_REGION'],
  s3_credentials: {
    bucket: ENV['AWS_BUCKET'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  },
  url: ":s3_domain_url",
  path: '/paperclip/:class/:id/:style_:filename',
  default_url: '/missing_images/:class.png',
  styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }
)
