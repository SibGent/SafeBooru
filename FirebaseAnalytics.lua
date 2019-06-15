local Analytics = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local platform_list = {"android", "ios"}
local firebaseAnalytics = nil
local isInit = false

local isPlatformAllowed


function Analytics.init()
	if isDevice then
		if isPlatformAllowed() then
			firebaseAnalytics = require "plugin.firebaseAnalytics"
			isInit = pcall(firebaseAnalytics.init)
		end
	end
end


function Analytics.logEvent(eventId, params)
	assert(eventId, "bad argument #1 to 'logEvent' (string expected, got no value)")
	assert(params, "bad argument #2 to 'logEvent' (table expected, got no value)")

	if isInit then
		firebaseAnalytics.logEvent(eventId, params)
	end
end


function Analytics.setUserProperties(name, property)
	assert(name, "bad argument #1 to 'setUserProperties' (string expected, got no value)")
	assert(property, "bad argument #2 to 'setUserProperties' (string expected, got no value)")

	if isInit then
		firebaseAnalytics.setUserProperties(name, property)
	end
end


function Analytics.setCurrentScreen(screenName, screenClass)
	assert(screenName, "bad argument #1 to 'setCurrentScreen' (string expected, got no value)")
	assert(screenClass, "bad argument #2 to 'setCurrentScreen' (string expected, got no value)")

	if isInit then
		firebaseAnalytics.setCurrentScreen(screenName, screenClass)
	end
end


function Analytics.addPaymentInfo()
	local params = {}

	if isInit then
		firebaseAnalytics.logEvent("add_payment_info", params)
	end
end


function Analytics.addToCart(item_id, item_name, item_categoty, quantity, params)
	assert(item_id, "bad argument #1 to 'addToCart' (string expected, got no value)")
	assert(item_name, "bad argument #2 to 'addToCart' (string expected, got no value)")
	assert(item_categoty, "bad argument #3 to 'addToCart' (string expected, got no value)")
	assert(quantity, "bad argument #4 to 'addToCart' (number expected, got no value)")

	local params = params or {}
	params.item_id = item_id
	params.item_name = item_name
	params.item_categoty = item_categoty
	params.quantity = quantity

	if isInit then
		firebaseAnalytics.logEvent("add_to_cart", params)
	end
end


function Analytics.addToWishlist(item_id, item_name, item_categoty, quantity, params)
	assert(item_id, "bad argument #1 to 'addToWishlist' (string expected, got no value)")
	assert(item_name, "bad argument #2 to 'addToWishlist' (string expected, got no value)")
	assert(item_categoty, "bad argument #3 to 'addToWishlist' (string expected, got no value)")
	assert(quantity, "bad argument #4 to 'addToWishlist' (number expected, got no value)")

	local params = params or {}
	params.item_id = item_id
	params.item_name = item_name
	params.item_categoty = item_categoty
	params.quantity = quantity

	if isInit then
		firebaseAnalytics.logEvent("add_to_wishlist", params)
	end
end


function Analytics.appOpen()
	local params = {}

	if isInit then
		firebaseAnalytics.logEvent("app_open", params)
	end
end


function Analytics.beginCheckout(value, currency, params)
	assert(value, "bad argument #1 to 'beginCheckout' (number expected, got no value)")
	assert(currency, "bad argument #2 to 'beginCheckout' (string expected, got no value)")

	local params = params or {}
	params.value = value
	params.currency = currency

	if isInit then
		firebaseAnalytics.logEvent("begin_checkout", params)
	end
end


function Analytics.campaignDetails(source, medium, campaing, params)
	assert(source, "bad argument #1 to 'campaignDetails' (string expected, got no value)")
	assert(medium, "bad argument #2 to 'campaignDetails' (string expected, got no value)")
	assert(campaing, "bad argument #3 to 'campaignDetails' (string expected, got no value)")

	local params = params or {}
	params.source = source
	params.medium = medium
	params.campaing = campaing

	if isInit then
		firebaseAnalytics.logEvent("campaign_details", params)
	end
end


function Analytics.checkoutProgress(checkout_step, checkout_option)
	assert(checkout_step, "bad argument #1 to 'checkoutProgress' (string expected, got no value)")
	assert(checkout_option, "bad argument #2 to 'checkoutProgress' (string expected, got no value)")

	local params = {}
	params.checkout_step = checkout_step
	params.checkout_option = checkout_option

	if isInit then
		firebaseAnalytics.logEvent("checkout_progress", params)
	end
end


function Analytics.earnVirtualCurrency(virtual_currency_name, value)
	assert(virtual_currency_name, "bad argument #1 to 'earnVirtualCurrency' (string expected, got no value)")
	assert(value, "bad argument #2 to 'earnVirtualCurrency' (number expected, got no value)")

	local params = {}
	params.virtual_currency_name = virtual_currency_name
	params.value = value

	if isInit then
		firebaseAnalytics.logEvent("earn_virtual_currency", params)
	end
end


function Analytics.ecommercePurchase(value, currency, params)
	assert(value, "bad argument #1 to 'ecommercePurchase' (number expected, got no value)")
	assert(currency, "bad argument #2 to 'ecommercePurchase' (string expected, got no value)")

	local params = params or {}
	params.currency = currency
	params.value = value

	if isInit then
		firebaseAnalytics.logEvent("ecommerce_purchase", params)
	end
end


function Analytics.generateLead(value, currency)
	assert(value, "bad argument #1 to 'generateLead' (number expected, got no value)")
	assert(currency, "bad argument #2 to 'generateLead' (string expected, got no value)")

	local params = {}
	params.currency = currency
	params.value = value

	if isInit then
		firebaseAnalytics.logEvent("generate_lead", params)
	end
end


function Analytics.joinGroup(group_id)
	assert(group_id, "bad argument #1 to 'joinGroup' (string expected, got no value)")

	local params = {}
	params.group_id = group_id

	if isInit then
		firebaseAnalytics.logEvent("join_group", params)
	end
end


function Analytics.levelUp(level, character)
	assert(level, "bad argument #1 to 'levelUp' (number expected, got no value)")

	local params = {}
	params.level = level
	params.character = character

	if isInit then
		firebaseAnalytics.logEvent("level_up", params)
	end
end


function Analytics.login()
	local params = {}

	if isInit then
		firebaseAnalytics.logEvent("login", params)
	end
end


function Analytics.postScore(score, level, character)
	assert(score, "bad argument #1 to 'postScore' (number expected, got no value)")

	local params = {}
	params.score = score
	params.level = level
	params.character = character

	if isInit then
		firebaseAnalytics.logEvent("post_score", params)
	end
end


function Analytics.presentOffer(item_id, item_name, item_categoty, quantity, params)
	assert(item_id, "bad argument #1 to 'presentOffer' (string expected, got no value)")
	assert(item_name, "bad argument #2 to 'presentOffer' (string expected, got no value)")
	assert(item_categoty, "bad argument #3 to 'presentOffer' (string expected, got no value)")
	assert(quantity, "bad argument #4 to 'presentOffer' (number expected, got no value)")

	local params = params or {}
	params.item_id = item_id
	params.item_name = item_name
	params.item_categoty = item_categoty
	params.quantity = quantity

	if params.value then
		assert(params.currency, "bad argument #5 to 'presentOffer' (string (currency) expected, got no value)")
	end

	if isInit then
		firebaseAnalytics.logEvent("present_offer", params)
	end
end


function Analytics.purchaseRefund(value, currency, transaction_id)
	assert(value, "bad argument #1 to 'purchaseRefund' (number expected, got no value)")
	assert(currency, "bad argument #2 to 'purchaseRefund' (string expected, got no value)")

	local params = {}
	params.value = value
	params.currency = currency
	params.transaction_id = transaction_id

	if isInit then
		firebaseAnalytics.logEvent("purchase_refund", params)
	end
end


function Analytics.removeFromCart(item_id, item_name, item_categoty, quantity, params)
	assert(item_id, "bad argument #1 to 'removeFromCart' (string expected, got no value)")
	assert(item_name, "bad argument #2 to 'removeFromCart' (string expected, got no value)")
	assert(item_categoty, "bad argument #3 to 'removeFromCart' (string expected, got no value)")
	assert(quantity, "bad argument #4 to 'removeFromCart' (number expected, got no value)")

	local params = params or {}
	params.item_id = item_id
	params.item_name = item_name
	params.item_categoty = item_categoty
	params.quantity = quantity

	if isInit then
		firebaseAnalytics.logEvent("remove_from_cart", params)
	end
end


function Analytics.search(search_term, params)
	assert(search_term, "bad argument #1 to 'search' (string expected, got no value)")

	local params = params or {}
	params.search_term = search_term

	if isInit then
		firebaseAnalytics.logEvent("search", params)
	end
end


function Analytics.selectContent(content_type, item_id)
	assert(content_type, "bad argument #1 to 'selectContent' (string expected, got no value)")
	assert(item_id, "bad argument #2 to 'selectContent' (string expected, got no value)")

	local params = {}
	params.content_type = content_type
	params.item_id = item_id

	if isInit then
		firebaseAnalytics.logEvent("select_content", params)
	end
end


function Analytics.setCheckoutOption(checkout_step, checkout_option)
	assert(checkout_step, "bad argument #1 to 'setCheckoutOption' (string expected, got no value)")
	assert(checkout_option, "bad argument #2 to 'setCheckoutOption' (string expected, got no value)")

	local params = {}
	params.checkout_step = checkout_step
	params.checkout_option = checkout_option

	if isInit then
		firebaseAnalytics.logEvent("set_checkout_option", params)
	end
end


function Analytics.share(content_type, item_id)
	assert(content_type, "bad argument #1 to 'share' (string expected, got no value)")
	assert(item_id, "bad argument #2 to 'share' (string expected, got no value)")

	local params = {}
	params.content_type = content_type
	params.item_id = item_id

	if isInit then
		firebaseAnalytics.logEvent("share", params)
	end
end


function Analytics.signUp(sign_up_method)
	assert(sign_up_method, "bad argument #1 to 'signUp' (string expected, got no value)")

	local params = {}
	params.sign_up_method = sign_up_method

	if isInit then
		firebaseAnalytics.logEvent("sign_up", params)
	end
end


function Analytics.spendVirtualCurrency(item_name, virtual_currency_name, value)
	assert(item_name, "bad argument #1 to 'spendVirtualCurrency' (string expected, got no value)")
	assert(virtual_currency_name, "bad argument #2 to 'spendVirtualCurrency' (string expected, got no value)")
	assert(value, "bad argument #3 to 'spendVirtualCurrency' (number expected, got no value)")

	local params = {}
	params.item_name = item_name
	params.virtual_currency_name = virtual_currency_name
	params.value = value

	if isInit then
		firebaseAnalytics.logEvent("spend_virtual_currency", params)
	end
end


function Analytics.tutorialBegin()
	local params = {}

	if isInit then
		firebaseAnalytics.logEvent("tutorial_begin", params)
	end
end


function Analytics.tutorialComplete()
	local params = {}

	if isInit then
		firebaseAnalytics.logEvent("tutorial_complete", params)
	end
end


function Analytics.unlockAchievement(achievement_id)
	assert(achievement_id, "bad argument #1 to 'unlockAchievement' (string expected, got no value)")

	local params = {}
	params.achievement_id = achievement_id

	if isInit then
		firebaseAnalytics.logEvent("unlock_achievement", params)
	end
end


function Analytics.viewItem(item_id, item_name, item_categoty, params)
	assert(item_id, "bad argument #1 to 'viewItem' (string expected, got no value)")
	assert(item_name, "bad argument #2 to 'viewItem' (string expected, got no value)")
	assert(item_categoty, "bad argument #3 to 'viewItem' (string expected, got no value)")

	local params = params or {}
	params.item_id = item_id
	params.item_name = item_name
	params.item_categoty = item_categoty

	if isInit then
		firebaseAnalytics.logEvent("view_item", params)
	end
end


function Analytics.viewItemList(item_categoty)
	assert(item_categoty, "bad argument #1 to 'viewItemList' (string expected, got no value)")

	local params = {}
	params.item_categoty = item_categoty

	if isInit then
		firebaseAnalytics.logEvent("view_item_list", params)
	end
end


function Analytics.viewSearchResult(search_term)
	assert(search_term, "bad argument #1 to 'viewSearchResult' (string expected, got no value)")

	local params = {}
	params.search_term = search_term

	if isInit then
		firebaseAnalytics.logEvent("view_search_results", params)
	end
end


function isPlatformAllowed()
    local isAllowed = false

    for i = 1, #platform_list do
        if platform == platform_list[i] then
            isAllowed = true
            break
        end
    end

    return isAllowed
end


return Analytics
