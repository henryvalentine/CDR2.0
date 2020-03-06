using System;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using CDR.Areas.Identity.Data;
using CDR.Models;

[assembly: HostingStartup(typeof(CDR.Areas.Identity.IdentityHostingStartup))]
namespace CDR.Areas.Identity
{
    public class IdentityHostingStartup : IHostingStartup
    {
        public void Configure(IWebHostBuilder builder)
        {
            builder.ConfigureServices((context, services) => {
                services.AddDbContext<CDRContext>(options =>
                    options.UseSqlServer(
                        context.Configuration.GetConnectionString("identity")));

                //services.AddIdentity<CDRUser, IdentityRole>().AddEntityFrameworkStores<CDRContext>();

                services.AddDefaultIdentity<CDRUser>()
                    .AddEntityFrameworkStores<CDRContext>();
            });
        }
    }
}