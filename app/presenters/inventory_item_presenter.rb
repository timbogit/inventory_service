class InventoryItemPresenter < ::Presenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper
  include Rails.application.routes.url_helpers

  ITEM_REPRESENTATIONS = [:full]

  IMAGE_URLS = [
    "https://a1.lscdn.net/imgs/6c2f477a-641b-4c0b-b97a-d060ead12ec1/540_q80.jpg",
    "https://a1.lscdn.net/imgs/6690de55-2c23-4e24-9bb5-1e745271d7a8/540_q80.jpg",
    "https://a1.lscdn.net/imgs/bc79d164-3ab6-4223-9404-39f67f85a030/540_q80.jpg",
    "https://a1.lscdn.net/imgs/0402309c-cedb-4f72-afba-8a3ea0173099/540_q80.jpg",
    "https://a0.lscdn.net/imgs/041c0679-ed59-48b7-9380-e5759495adac/540_q80.jpg",
    "https://a0.lscdn.net/imgs/faaffeb3-ec62-4ed9-b5d7-4aa049a3f7de/540_q80.jpg",
    "https://a0.lscdn.net/imgs/4666a90c-9ce7-4c1a-a838-7039a8dd5bde/540_q80.jpg",
    "https://a0.lscdn.net/imgs/168a2f0b-1663-4c75-af1d-6c8dc5592d6a/540_q80.jpg",
    "https://a1.lscdn.net/imgs/5c161267-3fd7-4146-b8da-03e810029f80/540_q80.jpg",
    "https://a0.lscdn.net/imgs/b286fd13-c9b0-4c66-90f7-3c20aaa22f9d/540_q80.jpg",
  ]

  DESCRIPTIONS = [
    "Lorem ipsum dolor sit amet, an electram constituto consequuntur mea. Vix commune pertinax perpetua te. Scriptorem necessitatibus nec ad, alia audire an pri. Inani vocibus scripserit ei has. Duo at delicata molestiae, in modus malis postulant eam, odio persius gubergren sit ne.",
    "Ea vix mollis impetus consequat, eum aperiam patrioque adversarium no. Cotidieque consequuntur ei his, accumsan consectetuer te pro. Ei labore singulis his, vis an nominavi qualisque vituperata. Eum ocurreret iracundia comprehensam ne, at eam mucius animal. Et case labitur maiestatis vix, unum nulla reprimique et eum. Percipitur efficiantur instructior at mel, sed prompta numquam percipitur at.",
    "Duis iudico ei duo, posse corpora id vel. Nam nemore malorum splendide at. Mel stet assueverit necessitatibus ad, vix id atqui tollit partem. Eu causae quaestio mea, ex deseruisse adipiscing cum, has id eleifend corrumpit.",
    "Illud graecis cu nec, an mea albucius accusata philosophia, ei omnes facilis epicuri sed. Id sed tation deleniti. Everti pericula est ei, at aperiri accommodare est. Alii dicat referrentur eos at, ea unum voluptatum per. Vix verear oportere ei, per ne rebum ullum alterum.",
    "Duo tincidunt appellantur ex, et nisl omittam nam. Ad putent tamquam eum, ceteros neglegentur vis an, et eos probo posse corrumpit. Facer vivendum no sit, accusam invenire duo eu. Vocent lobortis eu sea, no volutpat dignissim conclusionemque duo, in voluptua inciderint sit. Sit tota dolorum officiis ut, quando numquam ea pri. No vix quot oporteat, et aperiam suscipit imperdiet usu.",
    "Quis soluta vituperatoribus at per, platonem persequeris mediocritatem in pro, sed dolorum ponderum an. Ne dico similique quo, quis hendrerit vis ex. Nec in iriure tamquam complectitur, et vel quot adhuc volumus, esse eros consectetuer eu quo. Ea iusto assueverit eam, ad eum soleat impetus. Mollis laoreet imperdiet ius ei. Munere complectitur ea nec, alii complectitur contentiones ea duo.",
    "Ne his causae laoreet appareat, at nam dolores delicata, nec cu eirmod definitionem. In iriure aliquid incorrupte pri. Mel epicuri reformidans ex. His an partem integre aliquando, ad aliquando constituto has, ei cum iisque detraxit insolens. Unum errem convenire in est, sed no malis doming accusamus. No mel modus legimus appareat.",
    "Alia volutpat id has, te pro adhuc dicant libris, qui an ancillae antiopam. Has tempor molestie in. Ei postea luptatum legendos vix, in commodo utroque atomorum sea. Altera expetendis necessitatibus ea pro, agam erant mollis cum cu. Eu qui stet munere, omittam delicatissimi te est.",
    "Per euripidis definitiones ei, duo cu elit singulis. Equidem inciderint est ut, inimicus aliquando intellegat his ex, ex est verterem splendide. At vim dolores assueverit. Stet labores qualisque in eam, eu per case mutat. Oportere delicatissimi qui in, ex vim quem velit invenire.",
    "No qui aliquip detraxit senserit, case iracundia expetendis duo ex, an cibo dicam semper mei. Pri dico fastidii vivendum no, quidam noster intellegam ius te. Illud blandit vel ei, cu mea meis utamur accusam, alia hendrerit an duo. Te his nullam detracto, oratio feugiat mandamus has ad."
  ]

  attr_accessor :inventory_item

  def initialize(item)
    @inventory_item = item
    super(@inventory_item)
  end
end
