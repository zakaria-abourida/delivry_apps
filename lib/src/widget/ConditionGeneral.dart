import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../Constant.dart';

class ConditionGenerale {
  final BuildContext context;

  ConditionGenerale(this.context);
  double val = 200;
  static Future<void> openDialog(BuildContext context) async {
    var height = MediaQuery.of(context).size.height - 200.0;

    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(0),
            children: [
              SingleChildScrollView(
                  
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Icon(
                                        Icons.close,
                                        color: Constants.primaryColor,
                                      ),
                                    ),
                                  ),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  
                                  Text(
                                    'Conditions générales de vente',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "Les présentes conditions générales d’utilisation et informations légales « ci-dessous « s’appliquent à l’application mobile Webili App et son site Web. VEUILLEZ LIRE ATTENTIVEMENT LES PRÉSENTES CONDITIONS AVANT D'ACCÉDER AUX SERVICES OU DE LES UTILISER.Présentation de Webili APP .Webili APP est une plateforme de livraison 100% Marocaine",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Définitions :',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "Votre accès et Votre utilisation des Services sont soumis aux présentes Conditions que vous devez lire et accepter avant d'accéder aux services et de les utiliser. Votre acceptation des présentes Conditions établit une relation contractuelle entre vous et Webili APP. Si vous n'acceptez pas ces conditions, Vous ne pouvez accéder à, ou utiliser les Services. Les présentes Conditions remplacent expressément les précédents contrats ou accords conclus entre Vous et Webili APP. Des conditions complémentaires peuvent s'appliquer à certains Services, comme par exemple les conditions régissant un événement particulier ou une activité ou promotion particulière, et lesdites conditions complémentaires Vous seront communiquées dans l'Application et/ou le Site Internet, dans le cadre des Services concernés. Ces conditions complémentaires s'ajouteront aux présentes et seront réputées faire partie des Conditions pour les besoins des Services concernés, une fois que Vous les aurez lues et acceptées. Les conditions complémentaires prévaudront sur ces Conditions en cas de conflit à l'égard des Services concernés. Webili APP peut modifier les présentes Conditions à tout moment. Les Conditions modifiées Vous seront alors communiquées. En accédant aux Services ou en les utilisant, Vous accepterez d'être lié par les Conditions telles que modifiées au moment où Vous utilisez les Services. Vous reconnaissez que vous êtes et demeurez libre à tout moment d'utiliser ou non les Services.",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Commander :',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "Tout contrat pour la fourniture de Livraison de repas sur ce site internet se fait entre vous et le Restaurant partenaire; et tout contact se fait entre vous et Webili App. Vous acceptez de nous apporter toutes les informations vous concernant ainsi que votre commande. Lorsque vous passez une commande. Assurez-vous que ces informations sont exactes et à jour. Tous les biens, services ou livraison de repas que vous pouvez acheter sur ce site internet sont pour votre seul usage. Cet accord interdit de revendre ces biens, services ou livraison de repas ou d’agir pour le compte d’un tiers. Vous pouvez contracter les Services seulement en tant qu’acteur principal.. Merci de prendre en compte que certains biens ne sont pas destinés à certaines tranches d’âge. Assurez-vous que le produit correspond bien à l’âge de son destinataire, en lisant attentivement sa description. Lorsque vous passez une commande sur ce site internet, nous pouvons vous demander de fournir une adresse mail et un mot de passe. Vous devez vous assurer de conserver ces données personnelles, et de ne pas les communiquer à un tiers. Toute commande passée sur notre site internet ou autre plateforme liée est sujette à la disponibilité, la capacité de livraison, et à son acceptation par le restaurant partenaire et Webili APP. Une fois la commande passée en ligne, nous vous enverrons un email pour confirmer la réception de la commande. Cet email de confirmation sera envoyé automatiquement et vous donnera seulement les détails de la commande afin que vous puissiez vérifier leur exactitude. Le fait de recevoir une confirmation automatique ne signifie pas forcément que nous ou le Restaurant partenaire sommes à même d’honorer la commande. Une fois l’email de confirmation envoyé, nous vérifierons la disponibilité et la capacité de livraison. Si le Restaurant partenaire auprès duquel vous avez passé commande accepte cette commande, il le confirmera auprès de Webili APP. Si les détails de la commande sont exacts, le contrat sera confirmé par message textuel (SMS). Si des produits proposés par Webili APP sont commandés, Webili APP confirmera leur disponibilité en liaison ou non avec le Restaurant partenaire. Si la livraison de repas ou des produits ne sont plus disponibles ou si la capacité de livraison n’est pas suffisante, nous vous en tiendrons informé par message textuel (SMS) ou par appel téléphonique.",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Prix et Paiement',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "L'enregistrement et l'utilisation de la Plateforme sont entièrement gratuits pour les Clients. Le Client devra uniquement payer chaque service demandé par le biais de la Plateforme pour commander des produits, et pour communiquer par le biais de la Plateforme, ainsi que les services de livraison ou de courses fournis par des tiers. En outre, pour les services qui incluent l'achat d'un produit, l'Utilisateur devra payer le prix de ce produit. En s'inscrivant sur la Plateforme et en fournissant les données bancaires demandées, l'Utilisateur autorise expressément Webili APP à émettre des reçus pour le paiement des services demandés, y compris le prix et la livraison des produits commandés. Le prix total de chaque service sera composé d'un pourcentage variable en fonction du nombre de kilomètres parcourus et du temps pris par le Restaurant, ainsi que le prix établi par chaque commerçant, le cas échéant, si l’Utilisateur demande l'achat physique d'un produit ou service. Webili APP se réserve le droit de modifier le prix en fonction de la distance parcourue et/ou de la tranche horaire dans laquelle le service est fourni. Conformément à ces conditions, le Client aura le droit de connaître le montant approximatif de la rémunération du service avant de le contracter et de formaliser le paiement, sauf s’il n’a pas indiqué l'adresse de collecte. Les frais de livraison pourront varier en cas d’événement de force majeure indépendante de la volonté de Webili APP et entraînant une augmentation de ces frais. Les frais pourront comprendre des pourboires pour le Restaurant et/ou le magasin local, dont le montant sera laissé à l'entière discrétion de l'Utilisateur. Webili APP se réserve le droit de modifier ses prix à tout moment. Une telle modification prendra effet immédiatement après sa publication. L'Utilisateur autorise expressément Webili APP à lui envoyer par voie électronique, à l'adresse email fournie par l'Utilisateur lors de son inscription, les reçus des services contractés et/ou les factures générées. Si une facture est nécessaire, l'utilisateur devra saisir les données fiscales correspondantes sur la Plateforme avant de passer sa commande. Si un service est annulé par l'Utilisateur une fois que la préparation de la commande par le commerçant local a été confirmée et que l'Utilisateur en a été informé, Webili APP sera en droit de facturer au client les frais applicables dans chaque cas. De même, si l'Utilisateur a demandé au Restaurant d'acheter un produit pour son compte et que le Client annule sa commande après l'achat, ce dernier devra supporter le coût des services de livraison fournis par le Restaurant ainsi que le prix du produit. Tout ceci sans préjudice de la possibilité pour le Client de demander un nouveau service pour retourner les produits achetés ou les faire livrer à une adresse différente. Dans le cas de produits non périssables, l'Utilisateur pourra exercer son droit de rétractation vis-à-vis du commerçant qui lui a vendu les produits. Si l'Utilisateur souhaite exercer ce droit par le biais de Webili APP, il devra demander un nouveau service. Le paiement des produits et/ou services proposés sur la Plateforme et vendus en personne dans les Restaurants et/ou magasins et livrés ensuite aux Clients sera temporairement effectué envers Webili APP, qui enverra ensuite les fonds aux Restaurants et/ou magasins avec lesquels elle a un accord commercial en place. Les Restaurants et/ou établissements associés autorisent Webili APP à accepter les paiements pour leur compte. Le paiement du prix d’un produit (comme un aliment, une boisson, un cadeau, etc.) correctement effectué envers Webili APP déchargera donc le Client de son obligation de payer ledit prix au Restaurant et/ou à l’établissement associé. De même, le paiement du Client le libèrera de toute obligation à l'égard du Restaurant, le paiement intégral du Client déchargeant le Client de toute obligation qu'il pourrait avoir envers le Partenaire et/ou le Restaurant. Le paiement des produits et/ou services par les Clients sera reçu sur les comptes de Webili APP par l'intermédiaire d'un établissement de monnaie électronique. Les Établissements de monnaie électronique sont autorisés à fournir des services de paiement réglementés sur tous les territoires où Webili APP opère et sont en conformité avec la législation en vigueur applicable aux services de paiement pour les Plateformes comme Webili APP. En utilisant le prestataire de paiement auquel elle a fait appel à cet effet, et dans le seul but de vérifier les moyens de paiement fournis, Webili APP se réserve le droit, comme mesure de prévention des fraudes, de demander une pré-autorisation de paiement pour les produits commandés via la Plateforme. Cette pré-autorisation n'entraînera en aucun cas le paiement du montant total de la commande, étant donné qu'elle n'interviendra qu'après la mise à disposition des produits à l'utilisateur ou pour les raisons prévues aux présentes conditions générales de vente. Pour offrir un meilleur support aux utilisateurs, Webili APP sera leur premier point de contact et assumera la responsabilité des paiements effectués sur la Plateforme. Cette responsabilité inclura les remboursements, les retours, les annulations et la résolution anticipée des litiges, sans préjudice de toute action qui pourrait être entreprise par Webili APP vis-à-vis des établissements locaux en tant que seul vendeur physique des produits commandés par les utilisateurs. Conformément à ce qui précède, en cas de litige, Webili APP fournira la première ligne de support et remboursera l'Utilisateur si cela est jugé approprié. Si l'Utilisateur a un quelconque problème avec le déroulement de sa commande, il pourra contacter le service client de Webili APP par les moyens mis à la disposition des Utilisateurs sur la Plateforme.",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Livraison',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "Les plages de livraison au moment de la livraison doivent être considérées de manière approximative seulement, et peuvent varier. Les produits sont livrés à l’adresse saisie lors du passage de la commande. Si la livraison est effectuée par Webili APP ou une entreprise tierce choisie par Webili APP, nous ferons tout notre possible pour vous livrer dans les temps. Nous ne pourrons pas être tenus pour responsables d’un retard. Si la livraison n’est pas effectuée par le restaurant, ou Webili APP ainsi que l’entreprise qu’elle a choisi les commandes seront livrées par un coursier. Si les produits ne sont pas livrés dans le temps imparti, merci de contacter le Restaurant partenaire en premier lieu. Vous pouvez également nous contacter par téléphone ou par email, et nous ferons tout notre possible pour que vous soyez livrés le plus rapidement possible. En cas de livraison en retard, les frais de livraison ne seront ni pris en charge par Webili APP ni annulés. Tous les risques liés aux produits et à la livraison de repas vous seront transférés au moment de la livraison. Si vous n’acceptez pas votre commande au moment où elle est prête à être livrée, ou si ne nous ne pouvons pas vous livrer à temps à cause d’indications erronées ou par absence d’autorisations, nous considérerons les produits comme livrés et les risques et responsabilités liés aux produits vous seront transférés. Un stockage, une assurance ou d'autres coûts dus à notre incapacité à livrer le produit seront de votre responsabilité : Webili APP sera en droit de vous demander le remboursement intégral des frais occasionnés. Vous devez vous assurer qu’au moment de la livraison des repas et/ou des produits, les arrangements adéquats (y compris l’accès là où celà est nécessaire) sont en place pour une bonne livraison des produits. Nous ne pouvons être tenus pour responsables d’aucun dommage, coût ou dépense liés à ces produits quand ceux-ci sont liés à une incapacité du client à donner les accès ou les dispositions adéquats pour la livraison. Les Restaurants partenaires qui prépareront votre commande ont pour but : * de vous préparer votre commande ; * de livrer dans le temps imparti par le restaurant; * de vous informer s’ils estiment ne pas pouvoir livrer dans le temps imparti. Les Restaurants partenaires et nous-mêmes ne pouvons être tenus pour responsables d’aucune perte, passif, coût, dommage et intérêt ou dépenses liés à un retard de livraison.; Merci de prendre en compte l’impossibilité pour les Restaurants partenaires de livrer à certains endroits. Si c’est le cas, nous vous informerons par un SMS ou un appel téléphonique d’après avoir annulé la commande;",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Annulation',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "Si le restaurant ou établissement a déjà accepté la commande et commencé à la préparer, l'Utilisateur devra payer le prix des produits. L'Utilisateur sera informé de l'acceptation du restaurant par le biais de la Plateforme et/ou par e-mail à l'adresse e-mail enregistrée par l'Utilisateur. Si l'Utilisateur annule la commande une fois que le restaurant l'a déjà acceptée, l'Utilisateur devra payer les frais d'annulation. L'utilisateur sera informé de l'acceptation du Restaurant par le biais de la Plateforme. Si le restaurant ou établissement ont tous deux déjà accepté la commande, l'utilisateur devra payer à la fois le prix des produits et les frais d'annulation. L'utilisateur pourra vérifier le montant total des frais d'annulation pour chaque commande en cliquant sur le bouton « Annuler » de la Plateforme. Les frais à appliquer, basés sur les facteurs décrits ci-dessus, seront alors indiqués à l'Utilisateur. Dans le cas de certaines villes, il pourra être impossible de consulter les frais d'annulation directement sur la Plateforme. Dans ce cas, les frais d'annulation applicables seront ceux indiqués à l'annexe II des présentes. En outre, si au moment de l'annulation le Restaurant a déjà acheté le produit commandé ou contracté un service, l'utilisateur pourra demander au Restaurant de le retourner. À cette fin, l'Utilisateur devra payer l'intégralité du prix d'achat et des frais de livraison des produits, ainsi que le coût du service de retour. Si le Restaurant a pu retourner le produit, sa valeur sera remboursée à l'Utilisateur qui, comme mentionné ci-dessus, devra payer le coût des deux services de collecte et de livraison ainsi que le service de retour. Le retour sera dans tous les cas soumis à la politique de retour du commerçant, et le Client déclare donc qu'il est conscient que, dans le cas de produits périssables (par exemple des denrées alimentaires), le retour peut ne pas être possible et Webili APP aura donc le droit de lui facturer à la fois le produit déjà acheté par le Restaurant en vertu de son mandat et le coût du service de livraison engagé. Si le client a donné une adresse de livraison incorrecte pour les produits, il pourra entrer une nouvelle adresse à tout moment, à condition qu'elle se trouve dans la même ville que celle de la commande initiale, où Webili APP fournit son service d'intermédiation. Dans ce cas, le client devra commander un nouveau service et accepter de se voir facturer le montant correspondant à la nouvelle livraison. Si l'adresse se trouve dans une autre ville que celle indiquée à l'origine, celle-ci ne pourra pas être modifiée pour être livrée dans une nouvelle ville, et la commande sera annulée, le Client prenant à sa charge les frais qui en résultent comme prévu dans cet article. Webili APP se réserve le droit d'annuler une commande sans avoir à fournir de motif valable. En cas d'annulation à la demande de Webili APP, l'Utilisateur aura droit au remboursement du montant payé. Webili APP met à la disposition des consommateurs des formulaires de réclamation officiels, dans les langues officielles des pays dans lesquels Webili APP opère, en relation avec le service qu'elle propose. Le client pourra demander les formulaires de réclamation mentionnés ci-dessus au service client de Webili APP, et une option d'accès lui sera envoyée automatiquement. Le message e-mail du consommateur devra préciser l'endroit exact à partir duquel la demande est faite, qui devra être le même que le lieu où le service doit être fourni. En cas de doute, la réclamation devra être faite à ce dernier endroit.",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Information',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "Là où nous vous demandons des informations pour vous livrer les produits et services, vous acceptez de nous donner des informations complètes et exactes. Vous nous autorisez à utiliser, stocker ou traiter vos informations personnelles afin de vous livrer les produits et/ou services commandés, et à des fins marketings et de contrôle : nous pouvons donner vos informations personnelles à des tiers quand nous estimons que les services qu’ils offrent peuvent vous intéresser ou que c’est requis par la loi, ou encore pour vous livrer. Plus d’informations sont disponibles dans notre Politique de Confidentialité. Vous avez le droit de demander une copie des informations personnelles que nous possédons sur vous. Merci de nous contacter si vous souhaitez recevoir les informations.Sites liés sur notre site internet peuvent figurer des liens vers des sites tiers qui peuvent vous intéresser selon nous. Nous ne représentons pas la qualité des biens et services proposés par ces sites tiers et n’avons aucun contrôle sur le contenu ou la disponibilité de leurs sites. Nous ne pouvons pas accepter la responsabilité du contenu des sites tiers ou des produits et/ou servies qu’ils vous proposent.Nous prenons les réclamations très au sérieux et plaçons les clients au centre de notre activité. Nous faisons tout notre possible pour vous répondre dans les 5 jours ouvrés. Merci d’envoyer vos réclamations à service@webiliapp.ma ou bien nous contacter par notre service chat.",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Limitation de responsabilité',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "Nous prenons le plus grand soin de vérifier l’exactitude des données de l’application mobile. Si des erreurs apparaissent, nous nous en excusons. Nous ne pouvons pas garantir que l’utilisation de notre application sera faite à bon escient ou de manière totalement sûre. Nous ferons de notre mieux pour corriger de telles erreurs rapidement et efficacement. Nous ne pouvons pas non plus garantir que notre site ou le serveur sont vierges de tout virus ou bug ou représentent toutes les fonctionnalités, l’exactitude et la fiabilité du site internet. Nous ne garantissons pas non plus l’adéquation à l’usage. En acceptant ces termes d’utilisation, vous acceptez de nous décharger de toute responsabilité relevant de votre utilisation des informations provenant d’un parti tiers, de votre utilisation de nourriture ou boisson d’un Restaurant partenaire. Nous déclinons toute responsabilité pour la fourniture de la nourriture à emporter, biens et services autant que la loi ne nous l’autorise. Ceci n’affecte pas vos droits de consommateur. Si nous sommes reconnus responsables d’une perte ou dommage à votre encontre, la réparation se limite au montant que vous avez déboursé pour le produit ou service concerné. Nous ne pouvons pas accepter la responsabilité d’une perte, dommage ou dépense, y compris les pertes directes ou indirectes comme des pertes de profit pour vous. Cette limitation de responsabilité ne s’applique pas pour les blessures physiques ou le décès dus à notre négligence. Nous déclinons toute responsabilité concernant les retards, échecs, omissions ou pertes d’informations transmises, les virus ou autre contamination envoyés à votre ordinateur via notre site web. Webili APP ne sera tenus responsable d’aucune défaillance, erreur ou retard dans l'exécution de ses services ou durant la livraison de marchandises, lorsque ce défaut survient à la suite de tout acte ou omission, qui est hors de notre contrôle raisonnable, comme tous les événements extrêmes et inévitables causés directement et exclusivement par les forces de la nature et qui ne peuvent être ni prévus, ni contrôlés, ni empêchés par l'exercice de la prudence, de la diligence, y compris mais sans. Si nous avons vendu les mêmes produits ou des produits similaires à plusieurs clients et ne pouvons pas répondre à nos obligations à cause d’un événement de force majeure, nous pouvons décider à notre discrétion quelles commandes nous honorons. Les produits vendus par nos soins sont à usage domestique et à destination des consommateurs seulement. Nous déclinons toute responsabilité pour toute perte indirecte, conséquente, perte de données, perte de profit ou de revenus, dommages matériels et/ou pertes de parties tiers dus à l’utilisation de notre site internet ou de produits ou services vendus par nos soins. Nous avons effectué toutes les mesures nécessaires pour empêcher la fraude en ligne et s’assurer que les données vous concernant que nous avons recueillies sont stockées de façon sécurisée. Cependant, nous ne pouvons être tenus pour responsables dans le cas improbable d’une panne de nos serveurs ou des serveurs de partis tiers. Dans l’éventualité où Webili APP aurait raison de croire qu’il existerai un abus d’utilisation des bons de réduction et/ou codes de réduction ou une quelconque suspicion d’instance de fraude, Webili APP se verrait le droit de bloquer l’utilisateur (ou client) et se réserve le droit de refuser ses services dans le future au dit utilisateur. Aussi, en cas d’abus d’utilisation des bons et/ou codes de réduction, Webili APP se réserve le droit d’exiger une compensation et/ou des dommages et intérêts auprès du ou des violateurs. Les offres sont sujettes 0 la volonté de Webili APP et peuvent être retirées a tout moment sans notification.",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Promos',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "Webili APP pourra fournir périodiquement des offres promotionnelles et des réductions à certains utilisateurs pouvant entraîner la facturation de montants différents pour des Services de Tiers identiques ou semblables obtenus via l'utilisation des Services, et Vous acceptez que lesdites offres promotionnelles et réductions, sauf si elles sont également mises à Votre disposition, n'ont aucune incidence sur Votre utilisation des Services, des Services de Tiers et/ou sur les Frais qui Vous ont été appliqués.",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Généralités',
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "Tous les prix sont en dirhams.Nous pouvons sous-traiter toutes les parties des produits ou services que nous vous proposons et nous pouvons assigner une partie de nos droits cités dans ces CGV sans votre consentement ou sans vous en notifier par avance.Nous nous réservons le droit de modifier les Conditions Générales de Vente à tout moment sans vous en tenir informé.Le paiement doit être effectué au moment de la commande par carte bancaire, ou à la livraison en espèces. Le non-paiement de la commande à temps entraînera son annulation.Ne pas utiliser ou lancer de système ou programme automatique sur notre site internet ou ses fonctionnalités de commande en ligne.Ne pas collecter des données personnelles en continu sur le site internet, ne pas utiliser le système de communication fourni par le site pour toute demande à caractère commercial, ne pas solliciter les utilisateurs du site, ne pas distribuer de bons de réduction ou de bons d’achat en rapport avec notre site internet, ni pirater le site.Les Conditions Générales de Vente ainsi que la Politique de Confidentialité, une commande et une instruction de paiement constitue un accord entre vous et nous. Aucun autre terme ne peut faire partie de cet accord. Dans l’éventualité d’un conflit entre ces Conditions Générales de Vente et d’autres termes sur le site, les Conditions Générales de Vente prévalent.Si un terme ou une condition de notre accord est déterminé invalide, illégal ou inapplicable, les partis s’accordent sur le fait que ce terme ou cette condition doit être détruit et que le reste de l’accord continue sans ce terme ou cette condition.Ces Conditions Générales de Vente et notre accord doivent être gouvernés et interprétés selon les lois marocaines. Les partis sont soumis à la juridiction exclusive des tribunaux marocains.Tout retard ou incapacité à faire respecter les termes du présent contrat ne constitue pas une renonciation de notre part à nos droits sauf dans le cas où notre renonciation est confirmée par écrit.Ces Conditions Générales de Vente et un contrat (et toutes les obligations non-contractuelles qui y sont liées ou en découlent) doivent être gouvernés et interprétés en accord avec les lois marocaines. Nous et vous, nous soumettons à la non-exclusive juridiction des tribunaux marocains. Toutes les transactions, correspondance et contacts entre nous se feront en anglais.",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                ),
            ],
          );
        })) {
    }
  }
}
