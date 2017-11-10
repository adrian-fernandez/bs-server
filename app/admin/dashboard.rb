ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    div class: 'blank_slate_container', id: 'dashboard_default_message' do
      span class: 'blank_slate' do
        span I18n.t('active_admin.dashboard_welcome.welcome')
        small I18n.t('active_admin.dashboard_welcome.call_to_action')
      end
    end

    section 'Recently updated content' do
      table_for PaperTrail::Version.order('id desc').limit(20) do # Use PaperTrail::Version if this throws an error
        column('Item') { |v| link_to v.item, [:admin, v.item] } # Uncomment to display as link
        column('Type') { |v| v.item_type.underscore.humanize }
        column('Modified at') { |v| v.created_at.to_s :long }
        column('User') do |v|
          if v.whodunnit
            link_to User.find(v.whodunnit).email, [:user, User.find(v.whodunnit)]
          else
            'Unknown'
          end
        end
      end
    end
  end
end
