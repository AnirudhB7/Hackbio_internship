### **R Shiny and its application in cancer care for Sarcoma patients**

**Author:** Anirudh Bhatia

**Github Repo:** https://github.com/AnirudhB7/Hackbio_internship/blob/main/Stage_0.md

**Introduction:** 

Shiny is the R package that allows us to build interactive web applications. Shiny package is a self contained web framework for building interactive web applications using R programming\[1]. Further, an individual app created using this R package is called Shiny app which is user friendly, interactive and is viewed in a web browser. To run any Shiny app on the local machine R package is needed and for these applications to be available on the server, shiny server products are needed. This is advantageous, as with languages like Python, a user needs various dependencies to not only deploy but even test and configure their applications\[2]. 

In the field of biomedical research, where we deal with large volumes of data, it becomes really important to visualize this data interactively so that meaningful insights can be derived from it. Specifically, in cancer research, the R Shiny plays important roles where it can not only help to interact with complex volumes of data efficiently but also support clinicians and public health authorities to plan and make informed decisions. For instance, in the study conducted by Rose _et al.,_ we observe how the Shiny package has contributed in managing and analyzing the vast Pan Sarcoma database(PSDB) for sarcoma patients\[3]. 

**Results:**

The PSDB project utilizes R Shiny in projecting the real-time analysis of sarcoma patients, producing visual datasets that helped in identifying that out of 3291 confirmed cases 30.6% patients were metastatic and almost 93.5% received systemic therapy\[3]. 

**Methods:**
The researchers built a Model-View-Controller (MVC) framework where R shiny was integrated as a “view” component since its role was to primarily improve upon user interaction with database stored using REDCap\[4]. Using the R programming language, it allowed the researchers to implement Shiny as a bridge/platform where users could interact with complex databases stored in REDCap. Overall, R Shiny streamlined their research process.

**Discussions**

The R Shiny package was an important resource that the researchers used in interactive exploration of complex sarcoma datasets. Because it is an open source package, this allows the seamless collaboration among various stakeholders involved in the sarcoma research.

**Conclusion**

In the end, I conclude that R Shiny is an ingenious package as it allows both visualization and analysis of complex datasets. In the PSDB project, R shiny enabled efficient analysis of sarcoma datasets which helped in improving patient outcome insights.

**References**

1: Welcome to shiny. Shiny. (n.d.-a). https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/index.html 

2: Posted March 30, 2022 by Aaron Geller. (2023, November 13). Comparing python interactives to R shiny hero image. Research Computing and Data Services Resources. https://sites.northwestern.edu/researchcomputing/2022/03/30/comparing-python-interactives-to-r-shiny/ 

3: Rose, Brandon & Coelho, Priscila & Bialick, Steven & Patel, Pooja & Statz-Geary, Kurt & Nunez, Osvaldo & Dhir, Aditi & Kang, Alina & Thornton, Mason & Jonczak, Emily & D'Amato, Gina & Trent, Jonathan. (2023). Pan-sarcoma database (PSDB): A model-view-controller framework application utilizing REDCap, shiny, and R to create a continuous pipeline of sarcoma data that can inform the care of current patients.. JCO Oncology Practice. 19. 589-589. 10.1200/OP.2023.19.11_suppl.589. 

4: Redcap. REDCap. (n.d.). https://www.project-redcap.org/ 


