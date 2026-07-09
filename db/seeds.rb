admin = User.find_or_create_by!(email: "admin@medicareinaya.tn") do |u|
  u.password              = "admin.tn123"
  u.password_confirmation = "admin.tn123"
  u.first_name = "Admin"
  u.last_name  = "MedicareInaya"
  u.role       = "admin"
end
puts "Admin created: #{admin.email}"

Setting.find_or_create_by!(key: "pricing") { |s| s.value = { "margin" => 20, "promotion" => 20 } }
puts "Settings seeded"

[
  { question: "Quel est le délai de livraison ?",         answer: "Nous livrons sous 2 à 5 jours ouvrables selon votre région. Les commandes passées avant 14h sont expédiées le jour même.",                                    category: "Livraison", sort_order: 1 },
  { question: "Comment puis-je suivre ma commande ?",     answer: "Après confirmation de votre commande, vous recevrez un email avec un numéro de suivi. Vous pouvez également consulter l'état depuis votre espace client.", category: "Livraison", sort_order: 2 },
  { question: "Les produits sont-ils authentiques ?",     answer: "Oui, tous nos produits sont 100 % authentiques, importés directement des fabricants et distributeurs officiels agréés.",                                    category: "Produits",  sort_order: 1 },
  { question: "Comment contacter le service client ?",    answer: "Vous pouvez nous joindre via le formulaire de contact, par email à Ghofraninaya5@gmail.com ou par téléphone au +216 54 547 403 du dimanche au jeudi.",     category: "Général",   sort_order: 1 },
].each do |attrs|
  Faq.find_or_create_by!(question: attrs[:question]) do |f|
    f.answer     = attrs[:answer]
    f.category   = attrs[:category]
    f.sort_order = attrs[:sort_order]
    f.active     = true
  end
end
puts "FAQs seeded"
