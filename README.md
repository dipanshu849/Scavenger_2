# scavenger_2

A new Flutter project.
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Waste Collection And Management System for IIT Mandi, the proposed statement!🥶

## Approach
Both hardware and software,

NOTE: I will you terms, staff -> to the person hired by the WMS company
                        home -> for Residencial area
                        public -> general areas eg. parks or academic buildings
                        mess workers -> The person incharge of the mess ( Have mercy on the grammer part)

Software part;
For collection part:
  1. Collection itself involves many part
  2.  > From staff side ( Time scheduling, list of people, or can have data which day more staff will be required ) and
  3.  > From home side ( Most fundamental - waste is segregated properly or not)
  4.  > From public side ( Here comes waste segregation as well as waste generation ( specifically refring towards mess))

Lets address the point 3 first:

Now first, if we think about ## waste generation in public areas, two solution came to mind:
1. Aware the students ( As mostly mess is used by students) and
2. Force the rules or Apply fines or some other mean ( When it comes to mind there doesn't seem much problem, but there's a lot, a lot: eg. That day your stomach can go wrong and you may left more food on the plate or something like that)

Hence, lets go with option 1(only), and form given to this idea was based on digital wellbeing, why you ask (Students see the mobile more then surrounding world, so instead of passing templates it would be best to give the data on the screen)
so, the waste generated data would be shown on the main dashboard (TO EVERYONE IN THE COLLEGE), with some extra features ( like per meal and per mess generation, where we would be able to pin point the problem)
And lets also include, some environment degradatin news below that so they can be more aware.😈 (Don't get wrong I am doing work of an angel here)

WAIT WAIT!! how will we get that data?
-> well in my college there are some white board above the bins where waste generated every day every meal is written. 
WAIT THE SOLUTION IS ALREADY APPLIED THEN WHAT ARE YOU DOING?
-> Problems with old solution:
                             1. Its clearly not maintained clearly and you know what no one care (most of the students don't even look at that)
                             2. It not at one place, we can't pin point the problem like that, which will be solved by use (angles) 
                             3. The data is just getting waste, and will get it stored it somewhere -> which can further be used anywehre (eg some type of research or like what we are doint (most basic displaying it) but more could be achieved)
                             4. Some common problems like, it could be checked if all persons are doing what they are supposed to do (Transperency!)

One last problem how will mess workers send the data?
-> We will add the role of mess workers will open a very simple and differnet interface ( check the image in wiki page)

That was all I could think of waste generation part (half part of the 3 point mentioned in collection part), Alot are left,,



Now, lets address ## waste segregation in public:
We created an automated segregation bin (with BIO, NON-BIO, and OTHERS (METALS) [ Hardware part comes in picture here]
( Thats all to say there)

Lets address the point 2 now,
If you forgot it was from home side (waste is properly segregated), its easy we can force the professors and they will get fine if not done 😈 (Again, don't look like that, I am doing a work of angel here)
we will take about this feature in next point (Point 1)

Lets address the point 1 now, 
To the point -> we add a role of staff person ( like we did in mess worker), he will get the list of person, their pickUp status (boolean), and time.
The staff person will have a scanner ( For what?)

Idea: When a person will open the app with role as Resident, I will give them access to a feature named Tag Id. ( Which will be basically a random string of intergers and characters), but will point towards that particular resident and will give a one 
way function ( like you can't know the person with tag Id), but the person will always give that same Tag Id ( Forgot it if you didn't understand). Now, you will some how get the tag Id to the residence in solid form which they will you them on their 
garbage bags. (How can you say some how you mean) ok, you can talk to your college committe to get them done ( why would you send your own money😈 (no not agian, sorry)). This was the overall simple idea.
