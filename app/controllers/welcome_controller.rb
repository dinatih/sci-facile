class WelcomeController < ApplicationController
  def index
  end

  # Pages publiques - pas d'authentification requise
  before_action :set_meta_data

  def index
    # Page d'accueil SCI-Facile
    @hero_stats = {
      sci_created: 1250,
      satisfied_clients: 980,
      years_experience: 8
    }

    @featured_services = featured_services_data
    @testimonials = testimonials_data
    @latest_articles = latest_articles_data if defined?(Article)
  end

  def about
    # À propos de SCI-Facile
    @team_members = team_members_data
    @company_values = company_values_data
    @timeline = company_timeline_data
  end

  def services
    # Services offerts par SCI-Facile
    @service_categories = [
      {
        title: "Création de SCI",
        description: "Accompagnement complet pour la création de votre SCI",
        features: [
          "Rédaction des statuts personnalisés",
          "Immatriculation au greffe",
          "Ouverture du compte bancaire",
          "Suivi administratif complet"
        ],
        price: "À partir de 890€",
        popular: true
      },
      {
        title: "Gestion comptable",
        description: "Tenue de comptabilité et déclarations fiscales",
        features: [
          "Comptabilité mensuelle",
          "Déclarations fiscales",
          "Liasse fiscale annuelle",
          "Conseil fiscal personnalisé"
        ],
        price: "À partir de 150€/mois"
      },
      {
        title: "Optimisation fiscale",
        description: "Conseils pour optimiser la fiscalité de votre SCI",
        features: [
          "Audit fiscal gratuit",
          "Stratégies d'optimisation",
          "Suivi des évolutions légales",
          "Accompagnement personnalisé"
        ],
        price: "Sur devis"
      }
    ]
  end

  def pricing
    # Tarification SCI-Facile
    @pricing_plans = pricing_plans_data
    @included_services = included_services_data
    @faq_pricing = faq_pricing_data
  end

  def contact
    # Page de contact
    @contact_info = {
      address: "65 rue du Chevaleret, 75013 Paris",
      phone: "06 95 01 77 15",
      email: "david.herelle.pro@gmail.com",
      hours: "Lun-Ven 9h-18h"
    }

    @contact_form = ContactForm.new if defined?(ContactForm)
  end

  def legal
    # Mentions légales
    @company_info = {
      name: "SCI-Facile SARL",
      siret: "12345678901234",
      address: "65 rue du Chevaleret, 75013 Paris",
      phone: "06 95 01 77 15",
      email: "contact@sci-facile.com",
      capital: "10 000€",
      rcs: "Paris B 123 456 789"
    }
  end

  def privacy
    # Politique de confidentialité
    @last_updated = "15 janvier 2025"
  end

  def terms
    # Conditions générales d'utilisation
    @last_updated = "15 janvier 2025"
  end

  def faq
    # Foire aux questions
    @faq_categories = faq_categories_data
  end

  def blog
    # Liste des articles de blog (si implémenté)
    if defined?(Article)
      @articles = Article.published.order(created_at: :desc).page(params[:page]).per(9)
      @featured_article = Article.featured.first
      @categories = ArticleCategory.all if defined?(ArticleCategory)
    else
      redirect_to root_path, notice: "Blog bientôt disponible"
    end
  end

  def search
    # Recherche sur le site
    @query = params[:q]
    @results = []

    if @query.present?
      @results = perform_search(@query)
    end
  end

  # Action pour le formulaire de contact
  def create_contact
    @contact_form = ContactForm.new(contact_params)

    if @contact_form.valid?
      # Envoyer l'email de contact
      ContactMailer.new_message(@contact_form).deliver_later
      redirect_to contact_path, notice: "Votre message a été envoyé avec succès !"
    else
      @contact_info = contact_info_data
      render :contact
    end
  end

  private

    def set_meta_data
      # SEO et meta données par page
      case action_name
      when "index"
        @page_title = "SCI-Facile - Création et gestion de SCI simplifiées"
        @meta_description = "Créez et gérez votre SCI en toute simplicité avec SCI-Facile. Accompagnement complet, tarifs transparents, expertise comptable."
        @meta_keywords = "SCI, création SCI, gestion SCI, comptabilité SCI, fiscalité immobilière"
      when "about"
        @page_title = "À propos - SCI-Facile"
        @meta_description = "Découvrez SCI-Facile, votre partenaire de confiance pour la création et gestion de SCI."
      when "services"
        @page_title = "Nos services - SCI-Facile"
        @meta_description = "Découvrez tous nos services : création de SCI, gestion comptable, optimisation fiscale."
      when "pricing"
        @page_title = "Tarifs - SCI-Facile"
        @meta_description = "Découvrez nos tarifs transparents pour la création et gestion de votre SCI."
      when "contact"
        @page_title = "Contact - SCI-Facile"
        @meta_description = "Contactez-nous pour toutes vos questions sur les SCI."
      end
    end

    def featured_services_data
      [
        {
          icon: "building",
          title: "Création de SCI",
          description: "Création complète de votre SCI en 48h avec tous les documents nécessaires",
          link: "/services#creation-sci"
        },
        {
          icon: "calculator",
          title: "Gestion comptable",
          description: "Tenue de comptabilité et déclarations fiscales par nos experts",
          link: "/services#creation-sci"
        },
        {
          icon: "trending-up",
          title: "Optimisation fiscale",
          description: "Conseils personnalisés pour optimiser la fiscalité de votre patrimoine",
          link: "/services#creation-sci"
        }
      ]
    end

    def testimonials_data
      [
        {
          name: "Marie Dubois",
          role: "Propriétaire SCI",
          content: "SCI-Facile m'a accompagnée de A à Z. Service impeccable et très professionnel !",
          rating: 5
        },
        {
          name: "Pierre Martin",
          role: "Investisseur immobilier",
          content: "Création de ma SCI en 48h comme promis. Je recommande vivement !",
          rating: 5
        },
        {
          name: "Sophie Bernard",
          role: "Chef d'entreprise",
          content: "Excellent suivi comptable, toujours disponibles pour répondre à mes questions.",
          rating: 5
        }
      ]
    end

    def latest_articles_data
      return [] unless defined?(Article)
      Article.published.order(created_at: :desc).limit(3)
    end

    def team_members_data
      [
        {
          name: "David Herelle",
          role: "Fondateur & Expert-comptable",
          bio: "Fondateur de SCI-Facile, David est expert-informatique avec plus de 10 ans d'expérience dans la création et gestion de Services Informatiques.",
          image: "team/david-herelle.jpg"
        },
        {
          name: "Nicaise Eloidin",
          role: "Responsable juridique",
          bio: "Creatrice d'une SCI pour son patrimoine personnel, elle accompagne nos clients dans la création et la gestion de leur SCI.",
          image: "team/nicaise-eloidin.jpg"
        }
      ]
    end

    def company_values_data
      [
        {
          title: "Transparence",
          description: "Tarifs clairs, sans surprise, avec un devis détaillé"
        },
        {
          title: "Expertise",
          description: "Une équipe d'experts comptables et juristes à votre service"
        },
        {
          title: "Rapidité",
          description: "Création de votre SCI en 48h maximum"
        }
      ]
    end

    def company_timeline_data
      [
        { year: "2017", event: "Création de SCI-Facile" },
        { year: "2019", event: "1000ème SCI créée" },
        { year: "2022", event: "Lancement du service de gestion comptable" },
        { year: "2025", event: "Plus de 2000 clients satisfaits" }
      ]
    end

    def pricing_plans_data
      [
        {
          name: "Création SCI",
          price: "890€",
          description: "Création complète de votre SCI",
          features: [
            "Rédaction des statuts",
            "Immatriculation au greffe",
            "Publication annonce légale",
            "Dossier complet remis"
          ],
          popular: true
        },
        {
          name: "Gestion comptable",
          price: "150€/mois",
          description: "Tenue de comptabilité mensuelle",
          features: [
            "Saisie des écritures",
            "Déclarations fiscales",
            "Liasse fiscale annuelle",
            "Support téléphonique"
          ]
        }
      ]
    end

    def included_services_data
      [
        "Accompagnement personnalisé",
        "Suivi administratif complet",
        "Support client dédié",
        "Mises à jour réglementaires"
      ]
    end

    def faq_pricing_data
      [
        {
          question: "Y a-t-il des frais cachés ?",
          answer: "Non, tous nos tarifs sont transparents et incluent tous les frais obligatoires."
        },
        {
          question: "Puis-je changer de formule ?",
          answer: "Oui, vous pouvez modifier votre formule à tout moment."
        }
      ]
    end

    def faq_categories_data
      [
        {
          title: "Création de SCI",
          questions: [
            {
              question: "Combien de temps faut-il pour créer une SCI ?",
              answer: "La création d'une SCI avec SCI-Facile prend en moyenne 48h à 72h une fois tous les documents réunis."
            },
            {
              question: "Quel est le capital minimum pour une SCI ?",
              answer: "Il n'y a pas de capital minimum légal pour une SCI. Vous pouvez créer une SCI avec 1€ de capital."
            }
          ]
        },
        {
          title: "Gestion comptable",
          questions: [
            {
              question: "La comptabilité est-elle obligatoire pour une SCI ?",
              answer: "Une SCI doit tenir une comptabilité, mais celle-ci peut être simplifiée selon le régime fiscal choisi."
            }
          ]
        }
      ]
    end

    def contact_info_data
      {
        address: "123 Avenue des Champs-Élysées, 75008 Paris",
        phone: "01 23 45 67 89",
        email: "contact@sci-facile.com",
        hours: "Lun-Ven 9h-18h"
      }
    end
end
