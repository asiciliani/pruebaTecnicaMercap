!classDefinition: #TelephoneBillingTest category: #PruebaTecnicaMercap!
TestCase subclass: #TelephoneBillingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneBillingTest methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 02:05:59'!
toDo
	'
	- mejorar la rep del dia en que se llama (que sea una fecha completa y pueda elegir si es weekday o weekend)'! !


!TelephoneBillingTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:09:09'!
test01UnusedLineIsBilledBasicFee

	self assert: (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541143215678') totalDue equals: TelephoneLine basicMonthlyFee.! !

!TelephoneBillingTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:09:25'!
test02WeekDayWorkHoursLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541143215678').
	line2 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541145555555').
	callDuration := 2 * minute.
	line1 calls: line2 on: self weekDay at: self weekDayWorkingHoursTime for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekDayWorkHoursFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:09:53'!
test03WeekDayNonWorkHoursLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541143215678').
	line2 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541145555555').
	callDuration := 2 * minute.
	line1 calls: line2 on: self weekDay at: self weekDayNonWorkingHoursTime for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekDayNonWorkHoursFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:10:49'!
test04WeekendLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541143215678').
	line2 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541145555555').
	callDuration := 2 * minute.
	line1 calls: line2 on: self weekendDay at: self arbitraryTimeOfDay for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekendFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:11:33'!
test05NationalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541143215678'.
	line2 := TelephoneLine fromRegion: 'Rosario' in: 'Argentina' number: '+543411234567'.
	callDuration := 2 * minute.
	line1 calls: line2 on: self firstDayOfTodaysMonth at: self arbitraryTimeOfDay for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine nationalFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:12:22'!
test06InternationalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541143215678'.
	line2 := TelephoneLine fromRegion: 'Montevideo' in: 'Uruguay' number: '+598 2 123 4567'.
	callDuration := 2 * minute.
	line1 calls: line2 on: self firstDayOfTodaysMonth at: self arbitraryTimeOfDay for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine internationalFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'tests' stamp: 'AS 3/30/2025 22:16:45'!
test07BillIsCorrectlyGenerated
	
	| line localLine nationalLine internationalLine callDuration bill|
	line := TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541143215678'.
	localLine := TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina' number: '+541145555555'.
	nationalLine := TelephoneLine fromRegion: 'Rosario' in: 'Argentina' number: '+543411234567'.
	internationalLine := TelephoneLine fromRegion: 'Montevideo' in: 'Uruguay' number: '+598 2 123 4567'.
	callDuration := 3 * minute.
	
	line calls: localLine on: self weekDay at: self weekDayWorkingHoursTime for: callDuration.
	line calls: localLine on: self weekDay at: self weekDayNonWorkingHoursTime for: callDuration.
	line calls: localLine on: self weekendDay at: self arbitraryTimeOfDay for: callDuration.
	line calls: nationalLine on: self firstDayOfTodaysMonth at: self arbitraryTimeOfDay for: callDuration.
	line calls: internationalLine on: self firstDayOfTodaysMonth at: self arbitraryTimeOfDay for: callDuration.
	bill := TelephoneLineeBill for: line duringMonth: self firstDayOfTodaysMonth month.
	
	self assert: bill totalDue equals: (line basicMonthlyFee + 
	(callDuration  * (line weekDayWorkHoursFee  + line weekDayNonWorkHoursFee + line weekendFee + line nationalFee + line internationalFee))).
	self assert: bill basicMonthlyFee equals: line basicMonthlyFee.
	self assert: bill localUsage equals: (line weekDayWorkHoursFee  * callDuration) + (line weekDayNonWorkHoursFee * callDuration) + (line weekendFee * callDuration).
	self assert: bill nationalUsage equals: (line nationalFee) * callDuration.
	self assert: bill internationalUsage equals: (line internationalFee) * callDuration.
	self assert: bill show equals: (OrderedCollection with: 'Bill for line number ', bill line number , ' during period ', bill month asString
											           with: '		Monthly fee: ', bill basicMonthlyFee asString
												    with: 'Local usage: ', bill localUsage asString
												    with: 'National and international usage: ', bill nationalAndInternationalUsage asString
												    with: 'Total due: ' , bill totalDue asString).! !


!TelephoneBillingTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:10:41'!
arbitraryTimeOfDay

	^ TimeOfDay now! !

!TelephoneBillingTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:02:13'!
closestWeekDayTo: aDate
	| date |
	date := aDate.
	[date weekdayIndex between: 1 and: 5] whileFalse: [date := date next].
	^date! !

!TelephoneBillingTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:12:33'!
closestWeekendDayTo: aDate 
	| date |
	date := aDate.
	[date weekdayIndex between: 6 and: 7] whileFalse: [date := date next].
	^date! !

!TelephoneBillingTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:43:32'!
firstDayOfTodaysMonth

	^ Date newDay: 1 month: Date today month monthIndex year: Date today year yearNumber! !

!TelephoneBillingTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:43:32'!
weekDay

	^ self closestWeekDayTo: (self firstDayOfTodaysMonth) ! !

!TelephoneBillingTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:13:51'!
weekDayNonWorkingHoursTime

	^ WeekDayLocalCallBiller workingHoursStart previous:  1 * minute! !

!TelephoneBillingTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:13:31'!
weekDayWorkingHoursTime

	^ WeekDayLocalCallBiller workingHoursStart next: 1 * minute! !

!TelephoneBillingTest methodsFor: 'support' stamp: 'AS 3/30/2025 19:43:32'!
weekendDay

	^self closestWeekendDayTo: (self firstDayOfTodaysMonth) ! !


!classDefinition: #Call category: #PruebaTecnicaMercap!
Object subclass: #Call
	instanceVariableNames: 'caller callee date timeOfDay duration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!Call methodsFor: 'instance creation' stamp: 'AS 3/30/2025 19:07:12'!
initializeFrom: aCallingLine to: aLineThatIsCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration 
	caller := aCallingLine.
	callee := aLineThatIsCalled.
	date := aDayOfTheWeek.
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

!Call class methodsFor: 'instance creation' stamp: 'AS 3/29/2025 23:40:36'!
from: aCallingLine to: aLineThatIsCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration
	^self new initializeFrom: aCallingLine to: aLineThatIsCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration ! !


!classDefinition: #CallBiller category: #PruebaTecnicaMercap!
Object subclass: #CallBiller
	instanceVariableNames: 'call callToBill bill'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!CallBiller methodsFor: 'instance creation' stamp: 'AS 3/30/2025 01:33:57'!
initializeFor: aCallToBill 
	call := aCallToBill.! !

!CallBiller methodsFor: 'instance creation' stamp: 'AS 3/30/2025 21:20:28'!
initializeFor: aCallToBill in: aRequestingBill 
	call := aCallToBill.
	bill := aRequestingBill.! !


!CallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 21:53:18'!
addToBill

	self subclassResponsibility ! !

!CallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:25:06'!
cost
	
	^call duration * self fee! !

!CallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:25:30'!
fee
	self subclassResponsibility ! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CallBiller class' category: #PruebaTecnicaMercap!
CallBiller class
	instanceVariableNames: ''!

!CallBiller class methodsFor: 'instance creation' stamp: 'AS 3/30/2025 01:59:52'!
for: aCallToBill
	^(self allSubclasses detect: [:aSubclass | aSubclass canHandle: aCallToBill]) new initializeFor: aCallToBill.! !

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

!InternationalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 21:53:01'!
addToBill

	^bill addAsInternational: self cost.! !

!InternationalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:25:49'!
fee

	^ call caller class internationalFee! !

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

!LocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 21:52:54'!
addToBill

	^bill addAsLocal: self cost.! !

!LocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:25:25'!
fee
	self subclassResponsibility ! !


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

!WeekDayNonWorkingHoursLocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:26:21'!
fee

	^ call caller class weekDayNonWorkHoursFee! !

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

!WeekDayWorkingHoursLocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:26:28'!
fee

	^ call caller class weekDayWorkHoursFee! !

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

!WeekendLocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 19:58:00'!
fee

	^ call caller class weekendFee! !

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

!NationalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 21:52:41'!
addToBill

	^bill addAsNational: self cost.! !

!NationalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:26:04'!
fee

	^ call caller class nationalFee! !

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

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 18:06:35'!
totalDue
	^(outgoingCalls sum: [ :aCall | (CallBiller for: aCall) cost] ifEmpty: [0*dollar]) + self class basicMonthlyFee.! !

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 19:57:17'!
weekDayNonWorkHoursFee
	^self class weekDayNonWorkHoursFee ! !

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 19:57:02'!
weekDayWorkHoursFee
	^self class weekDayWorkHoursFee ! !

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 19:58:00'!
weekendFee
	^self class weekendFee ! !


!TelephoneLine methodsFor: 'testing' stamp: 'AS 3/30/2025 00:55:04'!
calls: aLineThatWasCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration
	outgoingCalls add: (Call from: self to: aLineThatWasCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration).! !

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

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/30/2025 19:58:00'!
weekendFee
	^0.12 * dollar / minute! !


!TelephoneLine class methodsFor: 'instance creation' stamp: 'AS 3/30/2025 22:14:29'!
fromRegion: aCallingRegion in: aCallingCountry number: aLineNumber   
	^self new initializeFromRegion: aCallingRegion in: aCallingCountry number: aLineNumber ! !


!classDefinition: #TelephoneLineeBill category: #PruebaTecnicaMercap!
Object subclass: #TelephoneLineeBill
	instanceVariableNames: 'line monthOfBilling total basicMonthlyFee localUsage nationalUsage internationalUsage'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneLineeBill methodsFor: 'instance creation' stamp: 'AS 3/30/2025 21:23:59'!
initializeFor: aLineToBill duringMonth: aMonthOfBilling 
	line := aLineToBill.
	monthOfBilling := aMonthOfBilling.
	basicMonthlyFee := line basicMonthlyFee. "Se hace una vez por si cambia en el futuro, pues quiero que la factura tenga la fee de ese momento."
	self calculateTotalCost.! !


!TelephoneLineeBill methodsFor: 'total - private' stamp: 'AS 3/30/2025 21:43:52'!
add: aCallCostToAdd 
	total := total + aCallCostToAdd ! !

!TelephoneLineeBill methodsFor: 'total - private' stamp: 'AS 3/30/2025 21:55:19'!
addAsInternational: anInternationalCallCostToAdd 
	internationalUsage := internationalUsage + anInternationalCallCostToAdd ! !

!TelephoneLineeBill methodsFor: 'total - private' stamp: 'AS 3/30/2025 21:55:35'!
addAsLocal: aLocalCallCostToAdd 
	localUsage := localUsage + aLocalCallCostToAdd ! !

!TelephoneLineeBill methodsFor: 'total - private' stamp: 'AS 3/30/2025 21:54:57'!
addAsNational: aNationalCallCostToAdd 
	nationalUsage := nationalUsage + aNationalCallCostToAdd ! !

!TelephoneLineeBill methodsFor: 'total - private' stamp: 'AS 3/30/2025 22:00:39'!
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


!TelephoneLineeBill methodsFor: 'total' stamp: 'AS 3/30/2025 21:15:27'!
totalDue
	^total! !


!TelephoneLineeBill methodsFor: 'fee' stamp: 'AS 3/30/2025 21:22:46'!
basicMonthlyFee
	^basicMonthlyFee! !


!TelephoneLineeBill methodsFor: 'local' stamp: 'AS 3/30/2025 21:25:08'!
localUsage
	^localUsage! !


!TelephoneLineeBill methodsFor: 'national' stamp: 'AS 3/30/2025 22:04:22'!
nationalUsage
	^nationalUsage! !


!TelephoneLineeBill methodsFor: 'international' stamp: 'AS 3/30/2025 22:04:33'!
internationalUsage
	^internationalUsage! !


!TelephoneLineeBill methodsFor: 'showing' stamp: 'AS 3/30/2025 22:18:36'!
show
	^(OrderedCollection with: 'Bill for line number ', line number , ' during period ', monthOfBilling asString
											           with: '		Monthly fee: ', basicMonthlyFee asString
												    with: 'Local usage: ', localUsage asString
												    with: 'National and international usage: ', self nationalAndInternationalUsage asString
												    with: 'Total due: ' , total asString).! !


!TelephoneLineeBill methodsFor: 'national and international' stamp: 'AS 3/30/2025 22:15:18'!
nationalAndInternationalUsage
	^nationalUsage + internationalUsage ! !


!TelephoneLineeBill methodsFor: 'line' stamp: 'AS 3/30/2025 22:16:06'!
line
	^line! !


!TelephoneLineeBill methodsFor: 'month' stamp: 'AS 3/30/2025 22:16:28'!
month
	^monthOfBilling ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TelephoneLineeBill class' category: #PruebaTecnicaMercap!
TelephoneLineeBill class
	instanceVariableNames: ''!

!TelephoneLineeBill class methodsFor: 'instance creation' stamp: 'AS 3/30/2025 21:03:54'!
for: aLineToBill duringMonth: aMonthOfBilling 
	^self new initializeFor: aLineToBill duringMonth: aMonthOfBilling ! !
