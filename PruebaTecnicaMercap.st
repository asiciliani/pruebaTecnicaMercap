!classDefinition: #TelephoneLineBillTest category: #PruebaTecnicaMercap!
TestCase subclass: #TelephoneLineBillTest
	instanceVariableNames: 'localLine1 localLine2 nationalLine internationalLine arbitraryCallDuration arbirtraryTimeOfDay'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:58:21'!
bill

	^ TelephoneLineBill for: localLine1 duringMonth: self firstDayOfTodaysMonth! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:52:30'!
internationalCost

	^ (localLine1 internationalFee) * arbitraryCallDuration! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:31:32'!
localLine1

	^ TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541143215678'! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:52:19'!
nationalCost

	^ (localLine1 nationalFee) * arbitraryCallDuration! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:58:50'!
test01UnusedLineIsBilledBasicFee
	
	self assert: self bill totalDue equals: localLine1 basicMonthlyFee.! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:59:22'!
test02WeekDayWorkHoursLocalCallIsBilledCorrectly
	
	localLine1 calls: localLine2 on: self weekDay at: self weekDayWorkingHoursTime for: arbitraryCallDuration.
	
	self assert: self bill totalDue equals: (localLine1 basicMonthlyFee ) + self weekDayWorkHoursCost .! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:59:20'!
test03WeekDayNonWorkHoursLocalCallIsBilledCorrectly
	
	localLine1 calls: localLine2 on: self weekDay at: self weekDayNonWorkingHoursTime for: arbitraryCallDuration.
	
	self assert: self bill totalDue equals: (localLine1 basicMonthlyFee ) + (self weekDayNonWorkHoursCost).! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:59:17'!
test04WeekendLocalCallIsBilledCorrectly
	
	localLine1 calls: localLine2 on: self weekendDay at:  arbirtraryTimeOfDay for: arbitraryCallDuration.
	
	self assert: self bill totalDue equals: (localLine1 basicMonthlyFee ) + self weekendCost.! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:59:41'!
test05NationalCallIsBilledCorrectly
	
	localLine1 calls: nationalLine on: self firstDayOfTodaysMonth at:  arbirtraryTimeOfDay for: arbitraryCallDuration.
	
	self assert: self bill totalDue equals: (localLine1 basicMonthlyFee ) + (self nationalCost).! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:59:59'!
test06InternationalCallIsBilledCorrectly
	
	localLine1 calls: internationalLine on: self firstDayOfTodaysMonth at:  arbirtraryTimeOfDay for: arbitraryCallDuration.
	
	self assert: self bill totalDue equals: (localLine1 basicMonthlyFee ) + (self internationalCost).! !

!TelephoneLineBillTest methodsFor: 'tests' stamp: 'AS 3/30/2025 23:00:43'!
test07BillIsCorrectlyGenerated
	
	| bill|
	
	localLine1 calls: localLine2 on: self weekDay at: self weekDayWorkingHoursTime for: arbitraryCallDuration.
	localLine1 calls: localLine2 on: self weekDay at: self weekDayNonWorkingHoursTime for: arbitraryCallDuration.
	localLine1 calls: localLine2 on: self weekendDay at:  arbirtraryTimeOfDay for: arbitraryCallDuration.
	localLine1 calls: nationalLine on: self firstDayOfTodaysMonth at:  arbirtraryTimeOfDay for: arbitraryCallDuration.
	localLine1 calls: internationalLine on: self firstDayOfTodaysMonth at:  arbirtraryTimeOfDay for: arbitraryCallDuration.
	bill := self bill.
	
	self assert: bill totalDue equals: (localLine1 basicMonthlyFee + 
	(arbitraryCallDuration  * (localLine1 weekDayWorkHoursFee  + localLine1 weekDayNonWorkHoursFee + localLine1 weekendFee + localLine1 nationalFee + localLine1 internationalFee))).
	self assert: bill basicMonthlyFee equals: localLine1 basicMonthlyFee.
	self assert: bill localUsage equals: (self weekDayWorkHoursCost) + (self weekDayNonWorkHoursCost) + (self weekendCost).
	self assert: bill nationalUsage equals: self nationalCost.
	self assert: bill internationalUsage equals: self internationalCost.
	self assert: bill show equals: (OrderedCollection with: 'Bill for line number ', bill line number , ' during period ', bill month asString
											           with: '		Monthly fee: ', bill basicMonthlyFee asString
												    with: 'Local usage: ', bill localUsage asString
												    with: 'National and international usage: ', bill nationalAndInternationalUsage asString
												    with: 'Total due: ' , bill totalDue asString).! !


!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:02:13'!
closestWeekDayTo: aDate
	| date |
	date := aDate.
	[date weekdayIndex between: 1 and: 5] whileFalse: [date := date next].
	^date! !

!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:12:33'!
closestWeekendDayTo: aDate 
	| date |
	date := aDate.
	[date weekdayIndex between: 6 and: 7] whileFalse: [date := date next].
	^date! !

!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:43:32'!
firstDayOfTodaysMonth

	^ Date newDay: 1 month: Date today month monthIndex year: Date today year yearNumber! !

!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:43:32'!
weekDay

	^ self closestWeekDayTo: (self firstDayOfTodaysMonth) ! !

!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 22:51:01'!
weekDayNonWorkHoursCost

	^ localLine1 weekDayNonWorkHoursFee * arbitraryCallDuration! !

!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:13:51'!
weekDayNonWorkingHoursTime

	^ WeekDayLocalCallBiller workingHoursStart previous:  1 * minute! !

!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 22:48:11'!
weekDayWorkHoursCost

	^ localLine1 weekDayWorkHoursFee  * arbitraryCallDuration! !

!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:13:31'!
weekDayWorkingHoursTime

	^ WeekDayLocalCallBiller workingHoursStart next: 1 * minute! !

!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 22:51:15'!
weekendCost

	^ localLine1 weekendFee * arbitraryCallDuration! !

!TelephoneLineBillTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:43:32'!
weekendDay

	^self closestWeekendDayTo: (self firstDayOfTodaysMonth) ! !


!TelephoneLineBillTest methodsFor: 'setUp/tearDown' stamp: 'AS 3/30/2025 22:56:42'!
setUp
	localLine1 :=  TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541143215678'.
	localLine2 := TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541145555555'.
	nationalLine := TelephoneLine fromRegion: 'Rosario' in: 'Argentina' number: '+543411234567'.
	internationalLine := TelephoneLine fromRegion: 'Montevideo' in: 'Uruguay' number: '+598 2 123 4567'.
	arbitraryCallDuration := 2 * minute.
	arbirtraryTimeOfDay := TimeOfDay now.! !


!classDefinition: #Call category: #PruebaTecnicaMercap!
Object subclass: #Call
	instanceVariableNames: 'caller callee date timeOfDay duration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!Call methodsFor: 'instance creation' stamp: 'AS 3/30/2025 22:27:49'!
initializeFrom: aCallingLine to: aLineThatIsCalled on: aDate at: aTimeOfDay for: aCallDuration 
	caller := aCallingLine.
	callee := aLineThatIsCalled.
	date := aDate.
	timeOfDay := aTimeOfDay.
	duration := aCallDuration.! !


!Call methodsFor: 'querying' stamp: 'AS 3/30/2025 01:14:38'!
isInternational

	^ (callee isFromSameCountryAs: caller) not! !

!Call methodsFor: 'querying' stamp: 'AS 3/30/2025 01:13:35'!
isLocal

	^ (callee isFromSameCountryAs: caller) and: [(callee isFromSameRegionAs: caller)]! !

!Call methodsFor: 'querying' stamp: 'AS 3/30/2025 01:14:22'!
isNational

	^ (callee isFromSameCountryAs: caller) and: [(callee isFromSameRegionAs: caller) not]! !


!Call methodsFor: 'duration' stamp: 'AS 3/30/2025 01:39:50'!
duration
	^duration ! !


!Call methodsFor: 'caller' stamp: 'AS 3/30/2025 18:08:36'!
caller
	^caller! !


!Call methodsFor: 'day' stamp: 'AS 3/30/2025 19:07:19'!
date
	^date! !


!Call methodsFor: 'time' stamp: 'AS 3/30/2025 01:48:56'!
timeOfDay
	^timeOfDay ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: #PruebaTecnicaMercap!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'instance creation' stamp: 'AS 3/30/2025 22:27:41'!
from: aCallingLine to: aLineThatIsCalled on: aDate at: aTimeOfDay for: aCallDuration
	^self new initializeFrom: aCallingLine to: aLineThatIsCalled on: aDate at: aTimeOfDay for: aCallDuration ! !


!classDefinition: #CallBiller category: #PruebaTecnicaMercap!
Object subclass: #CallBiller
	instanceVariableNames: 'call bill'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!CallBiller methodsFor: 'instance creation' stamp: 'AS 3/30/2025 21:20:28'!
initializeFor: aCallToBill in: aRequestingBill 
	call := aCallToBill.
	bill := aRequestingBill.! !


!CallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:25:06'!
cost
	
	^call duration * self fee! !

!CallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:25:30'!
fee
	self subclassResponsibility ! !


!CallBiller methodsFor: 'relaying' stamp: 'AS 3/30/2025 21:53:18'!
addToBill

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CallBiller class' category: #PruebaTecnicaMercap!
CallBiller class
	instanceVariableNames: ''!

!CallBiller class methodsFor: 'instance creation' stamp: 'AS 3/30/2025 21:21:55'!
for: aCallToBill in: aRequestingBill 
	^(self allSubclasses detect: [:aSubclass | aSubclass canHandle: aCallToBill]) new initializeFor: aCallToBill in: aRequestingBill.! !


!CallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 01:56:32'!
canHandle: aCallToBill 
	self subclassResponsibility ! !


!classDefinition: #InternationalCallBiller category: #PruebaTecnicaMercap!
CallBiller subclass: #InternationalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!InternationalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 22:28:49'!
fee

	^ call caller internationalFee! !


!InternationalCallBiller methodsFor: 'relaying' stamp: 'AS 3/30/2025 21:53:01'!
addToBill

	^bill addAsInternational: self cost.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternationalCallBiller class' category: #PruebaTecnicaMercap!
InternationalCallBiller class
	instanceVariableNames: ''!

!InternationalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 01:57:11'!
canHandle: aCallToBill
	^aCallToBill isInternational.! !


!classDefinition: #LocalCallBiller category: #PruebaTecnicaMercap!
CallBiller subclass: #LocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!LocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:25:25'!
fee
	self subclassResponsibility ! !



!LocalCallBiller methodsFor: 'relaying' stamp: 'AS 3/30/2025 21:52:54'!
addToBill

	^bill addAsLocal: self cost.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LocalCallBiller class' category: #PruebaTecnicaMercap!
LocalCallBiller class
	instanceVariableNames: ''!

!LocalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 18:18:02'!
canHandle: aCallToBill
	^false! !



!LocalCallBiller class methodsFor: 'querying' stamp: 'AS 3/30/2025 19:07:19'!
isCallOnAWeekDay: aCallToBill 
	^aCallToBill date isWeekDay! !


!classDefinition: #WeekDayLocalCallBiller category: #PruebaTecnicaMercap!
LocalCallBiller subclass: #WeekDayLocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!WeekDayLocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:31:10'!
fee
	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeekDayLocalCallBiller class' category: #PruebaTecnicaMercap!
WeekDayLocalCallBiller class
	instanceVariableNames: ''!

!WeekDayLocalCallBiller class methodsFor: 'querying' stamp: 'AS 3/30/2025 18:29:48'!
isCallDuringWorkingHours: aCallToBill 
	^ (self workingHoursStart <= aCallToBill timeOfDay) and: [aCallToBill timeOfDay <= (self workingHoursEnd)]! !


!WeekDayLocalCallBiller class methodsFor: 'working hours' stamp: 'AS 3/30/2025 18:30:03'!
workingHoursEnd

	^ 20:00! !

!WeekDayLocalCallBiller class methodsFor: 'working hours' stamp: 'AS 3/30/2025 18:30:11'!
workingHoursStart

	^ 8:00! !


!WeekDayLocalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 18:29:19'!
canHandle: aCallToBill
	^false! !


!classDefinition: #WeekDayNonWorkingHoursLocalCallBiller category: #PruebaTecnicaMercap!
WeekDayLocalCallBiller subclass: #WeekDayNonWorkingHoursLocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!WeekDayNonWorkingHoursLocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 22:28:56'!
fee

	^ call caller weekDayNonWorkHoursFee! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeekDayNonWorkingHoursLocalCallBiller class' category: #PruebaTecnicaMercap!
WeekDayNonWorkingHoursLocalCallBiller class
	instanceVariableNames: ''!

!WeekDayNonWorkingHoursLocalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 18:16:49'!
canHandle: aCallToBill
	^aCallToBill isLocal and: [(self isCallOnAWeekDay: aCallToBill) and: [(self isCallDuringWorkingHours: aCallToBill) not ] ].! !


!classDefinition: #WeekDayWorkingHoursLocalCallBiller category: #PruebaTecnicaMercap!
WeekDayLocalCallBiller subclass: #WeekDayWorkingHoursLocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!WeekDayWorkingHoursLocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 22:28:59'!
fee

	^ call caller weekDayWorkHoursFee! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeekDayWorkingHoursLocalCallBiller class' category: #PruebaTecnicaMercap!
WeekDayWorkingHoursLocalCallBiller class
	instanceVariableNames: ''!

!WeekDayWorkingHoursLocalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 18:16:14'!
canHandle: aCallToBill
	^aCallToBill isLocal and: [(self isCallOnAWeekDay: aCallToBill) and: [self isCallDuringWorkingHours: aCallToBill ] ].! !


!classDefinition: #WeekendLocalCallBiller category: #PruebaTecnicaMercap!
LocalCallBiller subclass: #WeekendLocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!WeekendLocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 22:29:02'!
fee

	^ call caller weekendFee! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeekendLocalCallBiller class' category: #PruebaTecnicaMercap!
WeekendLocalCallBiller class
	instanceVariableNames: ''!

!WeekendLocalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 18:17:24'!
canHandle: aCallToBill
	^aCallToBill isLocal and: [(self isCallOnAWeekDay: aCallToBill) not]! !


!classDefinition: #NationalCallBiller category: #PruebaTecnicaMercap!
CallBiller subclass: #NationalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!NationalCallBiller methodsFor: 'relaying' stamp: 'AS 3/30/2025 21:52:41'!
addToBill

	^bill addAsNational: self cost.! !


!NationalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 22:28:34'!
fee

	^ call caller nationalFee! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NationalCallBiller class' category: #PruebaTecnicaMercap!
NationalCallBiller class
	instanceVariableNames: ''!

!NationalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 01:57:34'!
canHandle: aCallToBill
	^aCallToBill isNational.! !


!classDefinition: #TelephoneLine category: #PruebaTecnicaMercap!
Object subclass: #TelephoneLine
	instanceVariableNames: 'region country outgoingCalls number'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 19:59:07'!
basicMonthlyFee
	^self class basicMonthlyFee ! !

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 19:58:45'!
internationalFee
	^self class internationalFee ! !

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 19:58:32'!
nationalFee
	^self class nationalFee ! !

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 19:57:17'!
weekDayNonWorkHoursFee
	^self class weekDayNonWorkHoursFee ! !

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 19:57:02'!
weekDayWorkHoursFee
	^self class weekDayWorkHoursFee ! !

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 19:58:00'!
weekendFee
	^self class weekendFee ! !


!TelephoneLine methodsFor: 'testing' stamp: 'AS 3/30/2025 22:27:27'!
calls: aLineThatWasCalled on: aDate at: aTimeOfDay for: aCallDuration
	outgoingCalls add: (Call from: self to: aLineThatWasCalled on: aDate at: aTimeOfDay for: aCallDuration).! !

!TelephoneLine methodsFor: 'testing' stamp: 'AS 3/30/2025 00:55:25'!
initialize
	outgoingCalls  := OrderedCollection new
	! !


!TelephoneLine methodsFor: 'instance creation' stamp: 'AS 3/30/2025 22:14:42'!
initializeFromRegion: aCallingRegion in: aCallingCountry number: aLineNumber   
	region := aCallingRegion.
	country := aCallingCountry.
	number := aLineNumber ! !


!TelephoneLine methodsFor: 'querying' stamp: 'AS 3/30/2025 00:47:17'!
isFromSameCountryAs: aTelephoneLine 
	^country = aTelephoneLine country.! !

!TelephoneLine methodsFor: 'querying' stamp: 'AS 3/30/2025 00:47:49'!
isFromSameRegionAs: aTelephoneLine 
	^region = aTelephoneLine region! !


!TelephoneLine methodsFor: 'country' stamp: 'AS 3/30/2025 00:44:43'!
country
	^country! !


!TelephoneLine methodsFor: 'region' stamp: 'AS 3/30/2025 00:47:59'!
region
	^region! !


!TelephoneLine methodsFor: 'calls' stamp: 'AS 3/30/2025 21:18:51'!
outgoingCalls
	"Podria argumentarse que rompe encapsulamiento, pero lo hago en pos de no agregarle logica de calculo de costos a la linea ya no que no tiene que ver con la esencia de este objeto."
	^outgoingCalls! !


!TelephoneLine methodsFor: 'number' stamp: 'AS 3/30/2025 22:07:33'!
number
	^number! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TelephoneLine class' category: #PruebaTecnicaMercap!
TelephoneLine class
	instanceVariableNames: ''!

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 18:55:35'!
basicMonthlyFee
	^10 * dollar! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 20:06:37'!
internationalFee
	^25 * dollar / minute! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 19:47:57'!
nationalFee
	^14 * dollar / minute.! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 19:06:34'!
weekDayNonWorkHoursFee
	^0.1 * dollar / minute! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 18:53:01'!
weekDayWorkHoursFee
	^0.2 * dollar / minute! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/30/2025 23:07:52'!
weekendFee
	^0.1 * dollar / minute! !


!TelephoneLine class methodsFor: 'instance creation' stamp: 'AS 3/30/2025 22:14:29'!
fromRegion: aCallingRegion in: aCallingCountry number: aLineNumber   
	^self new initializeFromRegion: aCallingRegion in: aCallingCountry number: aLineNumber ! !


!classDefinition: #TelephoneLineBill category: #PruebaTecnicaMercap!
Object subclass: #TelephoneLineBill
	instanceVariableNames: 'line monthOfBilling total basicMonthlyFee localUsage nationalUsage internationalUsage'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneLineBill methodsFor: 'instance creation' stamp: 'AS 3/30/2025 21:23:59'!
initializeFor: aLineToBill duringMonth: aMonthOfBilling 
	line := aLineToBill.
	monthOfBilling := aMonthOfBilling.
	basicMonthlyFee := line basicMonthlyFee. "Se hace una vez por si cambia en el futuro, pues quiero que la factura tenga la fee de ese momento."
	self calculateTotalCost.! !


!TelephoneLineBill methodsFor: 'total - private' stamp: 'AS 3/30/2025 21:55:19'!
addAsInternational: anInternationalCallCostToAdd 
	internationalUsage := internationalUsage + anInternationalCallCostToAdd ! !

!TelephoneLineBill methodsFor: 'total - private' stamp: 'AS 3/30/2025 21:55:35'!
addAsLocal: aLocalCallCostToAdd 
	localUsage := localUsage + aLocalCallCostToAdd ! !

!TelephoneLineBill methodsFor: 'total - private' stamp: 'AS 3/30/2025 21:54:57'!
addAsNational: aNationalCallCostToAdd 
	nationalUsage := nationalUsage + aNationalCallCostToAdd ! !

!TelephoneLineBill methodsFor: 'total - private' stamp: 'AS 3/30/2025 22:00:39'!
calculateTotalCost
	
	"Se podria argumentar que si agrego un tipo de llamada debo modificar este metodo, y que por lo tanto seria mejor sumar los costos
	de manera indistinta, pero creo que el hecho de que haya distintos tipos de llamada es esencial a la factura (por el enunciado), ya
	que entiendo que pide que se discriminen los costos, lo cual no se podria hacer si no se diferenciaran los tipos de estos.
	Por lo tanto tiene sentido tener que ademas modificar la factura si se agrega un nuevo tipo."
	
	localUsage := 0*dollar.
	nationalUsage := 0*dollar.
	internationalUsage := 0*dollar.
	line outgoingCalls do: [ :aCall | (CallBiller for: aCall in: self) addToBill].
	
	total := line basicMonthlyFee + localUsage + nationalUsage + internationalUsage.
	
	! !


!TelephoneLineBill methodsFor: 'total' stamp: 'AS 3/30/2025 21:15:27'!
totalDue
	^total! !


!TelephoneLineBill methodsFor: 'fee' stamp: 'AS 3/30/2025 21:22:46'!
basicMonthlyFee
	^basicMonthlyFee! !


!TelephoneLineBill methodsFor: 'local' stamp: 'AS 3/30/2025 21:25:08'!
localUsage
	^localUsage! !


!TelephoneLineBill methodsFor: 'national' stamp: 'AS 3/30/2025 22:04:22'!
nationalUsage
	^nationalUsage! !


!TelephoneLineBill methodsFor: 'international' stamp: 'AS 3/30/2025 22:04:33'!
internationalUsage
	^internationalUsage! !


!TelephoneLineBill methodsFor: 'showing' stamp: 'AS 3/30/2025 22:18:36'!
show
	^(OrderedCollection with: 'Bill for line number ', line number , ' during period ', monthOfBilling asString
											           with: '		Monthly fee: ', basicMonthlyFee asString
												    with: 'Local usage: ', localUsage asString
												    with: 'National and international usage: ', self nationalAndInternationalUsage asString
												    with: 'Total due: ' , total asString).! !


!TelephoneLineBill methodsFor: 'national and international' stamp: 'AS 3/30/2025 22:15:18'!
nationalAndInternationalUsage
	^nationalUsage + internationalUsage ! !


!TelephoneLineBill methodsFor: 'line' stamp: 'AS 3/30/2025 22:16:06'!
line
	^line! !


!TelephoneLineBill methodsFor: 'month' stamp: 'AS 3/30/2025 22:16:28'!
month
	^monthOfBilling ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TelephoneLineBill class' category: #PruebaTecnicaMercap!
TelephoneLineBill class
	instanceVariableNames: ''!

!TelephoneLineBill class methodsFor: 'instance creation' stamp: 'AS 3/30/2025 21:03:54'!
for: aLineToBill duringMonth: aMonthOfBilling 
	^self new initializeFor: aLineToBill duringMonth: aMonthOfBilling ! !
