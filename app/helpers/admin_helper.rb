module AdminHelper
  def admin_nav_link(emoji, label, path)
    active = current_page?(path) || request.path.start_with?(path.to_s.split("?").first)
    link_to path, class: "flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-colors #{active ? 'bg-sky-600 text-white' : 'text-gray-400 hover:bg-gray-800 hover:text-white'}" do
      "#{emoji} #{label}"
    end
  end
end
