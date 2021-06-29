using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http.Controllers;
using System.Web.Http.Metadata;

namespace MIS.API.Binders
{
    /// <summary>
    /// A Custom HttpParameterBinding to bind multiple parameters from request body
    /// </summary>
    public class SimplePostVariableParameterBinding : HttpParameterBinding
    {
        private const string MultipleBodyParameters = "MultipleBodyParameters";
        public SimplePostVariableParameterBinding(HttpParameterDescriptor descriptor)
            : base(descriptor)
        {
        }

        /// <summary>
        /// Check for simple binding parameters in POST data. Bind POST data as well as query string data
        /// </summary>
        /// <param name="metadataProvider"></param>
        /// <param name="actionContext"></param>
        /// <param name="cancellationToken"></param>
        /// <returns></returns>
        public override Task ExecuteBindingAsync(ModelMetadataProvider metadataProvider, HttpActionContext actionContext, CancellationToken cancellationToken)
        {
            string stringValue = null;
            TaskCompletionSource<AsyncVoid> tcs = new TaskCompletionSource<AsyncVoid>();
            try
            {
                NameValueCollection col = TryReadBody(actionContext.Request);
                if (col != null)
                    stringValue = col[Descriptor.ParameterName];
                // try reading query string if we have no POST/PUT match
                if (stringValue == null)
                {
                    var query = actionContext.Request.GetQueryNameValuePairs();
                    if (query != null)
                    {
                        var matches = query.Where(kv => kv.Key.ToLower() == Descriptor.ParameterName.ToLower());
                        if (matches.Count() > 0)
                            stringValue = matches.First().Value;
                    }
                }
                object value = StringToType(stringValue);

                // Set the binding result here
                SetValue(actionContext, value);

                // now, we can return a completed task with no result

                tcs.SetResult(default(AsyncVoid));

            }
            catch (Exception)
            {
                // logger.LogException("ExecuteBindingAsync", ex);
                //throw ex;
            }
            return tcs.Task;
            //NameValueCollection col = TryReadBody(actionContext.Request);
            //if (col != null)
            //    stringValue = col[Descriptor.ParameterName];

            //// try reading query string if we have no POST/PUT match
            //if (stringValue == null)
            //{
            //    var query = actionContext.Request.GetQueryNameValuePairs();
            //    if (query != null)
            //    {
            //        var matches = query.Where(kv => kv.Key.ToLower() == Descriptor.ParameterName.ToLower());
            //        if (matches.Count() > 0)
            //            stringValue = matches.First().Value;
            //    }
            //}

            //object value = StringToType(stringValue);

            //// Set the binding result here
            //SetValue(actionContext, value);

            //// now, we can return a completed task with no result
            //TaskCompletionSource<AsyncVoid> tcs = new TaskCompletionSource<AsyncVoid>();
            //tcs.SetResult(default(AsyncVoid));
            //return tcs.Task;
        }


        /// <summary>
        /// Method that implements parameter binding hookup to the global configuration object's ParameterBindingRules collection delegate.
        /// This routine filters based on POST/PUT method status and simple parameter types.
        /// </summary>
        /// <param name="descriptor"></param>
        /// <returns></returns>
        public static HttpParameterBinding HookupParameterBinding(HttpParameterDescriptor descriptor)
        {
            //var supportedMethods = descriptor.ActionDescriptor.SupportedHttpMethods;

            //// Only apply this binder on POST and PUT operations
            //if (supportedMethods.Contains(HttpMethod.Post) || supportedMethods.Contains(HttpMethod.Put))
            //{
            //    var supportedTypes = new Type[] { typeof(string), 
            //                                    typeof(int), 
            //                                    typeof(decimal), 
            //                                    typeof(double), 
            //                                    typeof(bool),
            //                                    typeof(DateTime),
            //                                    typeof(byte[])
            //                                };

            //    if (supportedTypes.Where(typ => typ == descriptor.ParameterType).Count() > 0)
            //        return new SimplePostVariableParameterBinding(descriptor);
            //}

            try
            {
                var supportedMethods = descriptor.ActionDescriptor.SupportedHttpMethods;
                // Only apply this binder on POST operations
                if (supportedMethods.Contains(HttpMethod.Post))
                {
                    var supportedTypes = new Type[] { typeof(string),
                                                typeof(int),
                                                typeof(long),
                                                typeof(long?),
                                                typeof(decimal),
                                                typeof(double),
                                                typeof(bool),
                                                typeof(DateTime),
                                                typeof(byte[])
                                            };
                    if (supportedTypes.Count(typ => typ == descriptor.ParameterType) > 0)
                        return new SimplePostVariableParameterBinding(descriptor);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return null;
        }


        private object StringToType(string stringValue)
        {
            object value = null;

            //if (stringValue == null)
            //    value = null;
            //else if (Descriptor.ParameterType == typeof(string))
            //    value = stringValue;
            //else if (Descriptor.ParameterType == typeof(int))
            //    value = int.Parse(stringValue, CultureInfo.CurrentCulture);
            //else if (Descriptor.ParameterType == typeof(Int32))
            //    value = Int32.Parse(stringValue, CultureInfo.CurrentCulture);
            //else if (Descriptor.ParameterType == typeof(Int64))
            //    value = Int64.Parse(stringValue, CultureInfo.CurrentCulture);
            //else if (Descriptor.ParameterType == typeof(decimal))
            //    value = decimal.Parse(stringValue, CultureInfo.CurrentCulture);
            //else if (Descriptor.ParameterType == typeof(double))
            //    value = double.Parse(stringValue, CultureInfo.CurrentCulture);
            //else if (Descriptor.ParameterType == typeof(DateTime))
            //    value = DateTime.Parse(stringValue, CultureInfo.CurrentCulture);
            //else if (Descriptor.ParameterType == typeof(bool))
            //{
            //    value = false;
            //    if (stringValue == "true" || stringValue == "on" || stringValue == "1")
            //        value = true;
            //}
            //else
            //    value = stringValue;

            try
            {
                if (stringValue == null)
                    value = null;
                else if (Descriptor.ParameterType == typeof(string))
                    value = stringValue;
                else if (Descriptor.ParameterType == typeof(int))
                    value = int.Parse(stringValue, CultureInfo.CurrentCulture);
                else if (Descriptor.ParameterType == typeof(Int32))
                    value = Int32.Parse(stringValue, CultureInfo.CurrentCulture);
                else if (Descriptor.ParameterType == typeof(Int64))
                    value = Int64.Parse(stringValue, CultureInfo.CurrentCulture);
                else if (Descriptor.ParameterType == typeof(decimal))
                    value = decimal.Parse(stringValue, CultureInfo.CurrentCulture);
                else if (Descriptor.ParameterType == typeof(double))
                    value = double.Parse(stringValue, CultureInfo.CurrentCulture);
                else if (Descriptor.ParameterType == typeof(DateTime))
                    value = DateTime.Parse(stringValue, CultureInfo.CurrentCulture);
                else if (Descriptor.ParameterType == typeof(bool))
                {
                    value = false;
                    if (stringValue == "true" || stringValue == "on" || stringValue == "1")
                        value = true;
                }
                else
                    value = stringValue;
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return value;
        }

        /// <summary>
        /// Read and cache the request body
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        private NameValueCollection TryReadBody(HttpRequestMessage request)
        {
            object result = null;

            //// try to read out of cache first
            //if (!request.Properties.TryGetValue(MultipleBodyParameters, out result))
            //{
            //    var contentType = request.Content.Headers.ContentType;

            //    // only read if there's content and it's form data
            //    if (contentType == null || contentType.MediaType != "application/x-www-form-urlencoded")
            //    {
            //        // Nope no data
            //        result = null;
            //    }
            //    else
            //    {
            //        // parsing the string like firstname=Hongmei&lastname=ASDASD            
            //        result = request.Content.ReadAsFormDataAsync().Result;
            //    }

            //    request.Properties.Add(MultipleBodyParameters, result);
            //}

            try
            {
                var contentTypesList = new List<string>() { "application/x-www-form-urlencoded", "application/octet-stream" };

                if (!request.Properties.TryGetValue(MultipleBodyParameters, out result))
                {
                    var contentType = request.Content.Headers.ContentType.MediaType.ToLower();
                    if (contentType == null)
                    {
                        result = null;
                    }
                    else if (contentType.Contains("application/json"))
                    {
                        var jsonStr = request.Content.ReadAsStringAsync().Result;//{"Name":"Sudhanshu","Age":22}
                        var json = JsonConvert.DeserializeObject<IDictionary<string, string>>(jsonStr);
                        if (json != null || json.Count > 0)
                        {
                            var nvc = new NameValueCollection();
                            foreach (var item in json)
                            {
                                nvc.Add(item.Key, item.Value);
                            }
                            result = nvc;
                        }
                    }
                    else if (contentTypesList.Contains(contentType))
                    {
                        result = request.Content.ReadAsFormDataAsync().Result;
                    }
                    else
                    {
                        result = null;
                    }
                    request.Properties.Add(MultipleBodyParameters, result);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result as NameValueCollection;
        }

        private struct AsyncVoid
        {
        }

    }
}