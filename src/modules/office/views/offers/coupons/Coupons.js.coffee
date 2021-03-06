@Iconto.module 'office.views.offers', (Offers) ->
	class Offers.CouponItemView extends Marionette.ItemView
		className: 'coupon-item-view'
		template: JST['office/templates/offers/coupons/coupon-item']

		events:
			'click button': 'onClick'

		onClick: =>
			@trigger 'click', @model

	class Offers.CouponsView extends Iconto.shared.views.infinite.BaseInfiniteCompositeView
		className: 'coupons-view mobile-layout with-bottombar'
		template: JST['office/templates/offers/coupons/coupons']
		childView: Offers.CouponItemView
		childViewContainer: '.list'

		behaviors:
			Epoxy: {}
			Layout:
				template: JST['shared/templates/mobile-layout']
				outlets:
					bottombar: JST['office/templates/offers/bottombar']

		ui:
			topbarRightButton: '.topbar-region .right-small'

		events:
			'click @ui.topbarRightButton': 'onTopbarRightButtonClick'

		serializeData: =>
			state: @state.toJSON()

		getQuery: =>
			company_id: @state.get('companyId')
			order: 'desc'

		initialize: =>
			@state = new Iconto.office.models.StateViewModel @options
			@state.set
				topbarTitle: "#{@options.company.name}#{Iconto.shared.helpers.legal.getLegal(@options.legal, leadingComma: true)}"
				topbarSubtitle: 'Предложения'
				topbarRightButtonSpanClass: 'ic-plus-circle'

			@collection = new Iconto.REST.CouponCollection()

		onChildviewClick: (childView, itemModel) =>
			Iconto.office.router.navigate "office/#{@state.get('companyId')}/offers/coupon/#{itemModel.get('id')}", trigger: true

		onRender: =>
			@preload()
			.done =>
				@state.set
					isLoading: false

		onTopbarRightButtonClick: =>
			Iconto.office.router.navigate "office/#{@state.get('companyId')}/offers/coupon/new", trigger: true


