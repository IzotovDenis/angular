Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( editable/loading.gif )
Rails.application.config.assets.precompile += %w( editable/clear.png )
Rails.application.config.assets.precompile += %w( admin.js )
Rails.application.config.assets.precompile += %w( dashboard.js )
Rails.application.config.assets.precompile += %w( admin.css )
Rails.application.config.assets.precompile += %w( app/templates/* )